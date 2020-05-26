module FixturesHelper
  def locale_import_data_fixture
    {
      "group_one" => {
        "subgroup_one" => {
          "items" => [
            {
              "id" => "0001",
              "text" => "This is a row that only has text, it will appear like a paragraph",
            },
            {
              "href" => "http://test.stubbed.gov.uk",
              "id" => "0002",
              "text" => "This is a row has text and an href, it will appear as an anchor tag",
            },
            {
              "href" => "http://test.stubbed.llyw.cymru",
              "id" => "0003",
              "show_to_nations" => %w[
                Wales
              ],
              "text" => "This is a row has text, an href and group criteria, it will appear as an anchor tag if the user's answers match the criteria",
            },
          ],
          "support_and_advice" => [
            {
              "href" => "http://test.stubbed.gb.gov.uk",
              "id" => "0004",
              "show_to_nations" => %w[
                Wales
                Scotland
                England
              ],
              "text" => "This is a row has text, an href and multiple group criteria, it will appear as an anchor tag if the user's answers match the more complex criteria",
            },
          ],
        },
        "subgroup_two" => {
          "items" => [
            {
              "id" => "0005",
              "text" => "This is a row that only has text, it will appear like a paragraph",
            },
          ],
        },
      },
      "group_two" => {
        "subgroup_one" => {
          "items" => [
            {
              "id" => "0006",
              "text" => "This is a row that only has text, it will appear like a paragraph",
              "show_to_vulnerable_person" => true,
            },
          ],
        },
      },
    }
  end
end
