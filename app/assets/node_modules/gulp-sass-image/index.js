const fs = require('fs');
const path = require('canonical-path');
const log = require('fancy-log');
const colors = require('ansi-colors');
const Vinyl = require('vinyl');
const Through = require('through');
const mustache = require('mustache');
const sizeOf = require('image-size');
const mime = require('mime');
const md5 = require('md5');
const SVGO = require('svgo');
const appRoot = require('app-root-path').path;

const svgo = new SVGO();

let images = [];
let options = {
    template: path.join(__dirname, 'sass-image-template.mustache'),
    targetFile: '_sass-image.scss',
    prefix: '',
};

function pathPrefix() {
    let result = '';

    if (options.http_images_path) {
        result = options.http_images_path;
    } else if (options.css_path && options.images_path) {
        // Relative path from css folder to images
        result = path.relative(options.css_path, options.images_path);
    } else if (options.images_path) {
        // Relative from project url
        result = path.relative(appRoot, options.images_path);
    }

    // Make sure pathPrefix ends with a trailing slash
    if (result && result.substr(-1) !== '/') {
        result = `${result}/`;
    }

    return result;
}

function isSet(val) {
    return typeof val !== 'undefined' && val !== null;
}

function getSvgDimensions(file) {
    let dimensions = {
        width: undefined,
        height: undefined,
    };

    try {
        dimensions = sizeOf(file.path);
    } catch (e) {
        // Could not read width/height from svg. Try again with the slower svgo parser:
        svgo.optimize(file.contents.toString(), (res) => {
            // Check if dimensions could be read, log notice if not
            if (!isSet(res) || !isSet(res.info) || !isSet(res.info.width) || !isSet(res.info.height)) {
                const filePath = path.relative(options.images_path, file.path);
                log(
                    colors.yellow('NOTICE'),
                    'Image Dimensions could not be determined for:',
                    colors.cyan(filePath)
                );
                return;
            }
            dimensions = {
                width: res.info.width,
                height: res.info.height,
            };
        });
    }

    return dimensions;
}

function bufferContents(file) {
    if (!options.images_path) {
        // Autodetect images_path with the first file
        options.images_path = path.relative(appRoot, file.base);
    }

    const imageInfo = {};
    let encoding = 'base64';
    let data;

    const mimetype = mime.getType(file.path);
    let dimensions;

    if (mimetype === 'image/svg+xml') {
        dimensions = getSvgDimensions(file);
        encoding = 'charset=utf8';
        data = file.contents.toString('utf8');
        data = data.replace(/'/g, '"');
        data = data.replace(/\s+/g, ' ');
        data = data.replace(
            /[\(\){}\|\\\^~\[\]`"<>#%]/g,
            match => `%${match[0].charCodeAt(0).toString(16).toUpperCase()}`
        );
    } else {
        dimensions = sizeOf(file.path);
        data = file.contents.toString(encoding);
    }

    imageInfo.width = dimensions.width;
    imageInfo.height = dimensions.height;
    imageInfo.mime = mimetype;
    imageInfo.filename = path.basename(file.path);
    imageInfo.basename = path.basename(file.path, path.extname(file.path));
    imageInfo.dirname = path.basename(path.dirname(file.path));
    imageInfo.ext = path.extname(file.path);
    imageInfo.path = path.relative(options.images_path, file.path);
    // Replace /, \, . and @ with -
    imageInfo.fullname = imageInfo.path.replace(/[\/\\\.@]/g, '-');
    imageInfo.hash = md5(file.contents);
    imageInfo.data = `url("data:${mimetype};${encoding},${data}")`;

    images.push(imageInfo);
}

function endStream() {
    const template = fs.readFileSync(options.template).toString();

    this.emit('data', new Vinyl({
        contents: Buffer.from(mustache.render(template, {
            prefix: options.prefix,
            path_prefix: pathPrefix(),
            items: images,
            includeData: options.includeData,
            createPlaceholder: options.createPlaceholder,
        }), 'utf8'),
        path: options.targetFile,
    }));
    this.emit('end');
}

module.exports = (opts = {}) => {
    images = [];
    options = Object.assign(options, opts);

    if (options.includeData !== false) {
        options.includeData = true;
    }

    if (options.createPlaceholder !== false) {
        options.createPlaceholder = true;
    }

    return new Through(bufferContents, endStream);
};
