module.exports = {
    extends: 'airbnb-base',
    env: {
        browser: false,
        node: true
    },
    rules: {
        'indent': [2, 4],
        'no-param-reassign': 0,
        'max-len': ['error', 120, 2, {
            ignoreUrls: true,
            ignoreComments: false,
            ignoreRegExpLiterals: true,
            ignoreStrings: true,
            ignoreTemplateLiterals: true,
        }],
        'no-useless-escape': 0,
        'comma-dangle': ['error', {
            arrays: 'always-multiline',
            objects: 'always-multiline',
            imports: 'always-multiline',
            exports: 'always-multiline',
            functions: 'never',
        }],
    },
};
