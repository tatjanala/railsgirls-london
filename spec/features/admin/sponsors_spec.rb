require "spec_helper"

feature "admin CRUDing sponsors" do
  let(:name) { Faker::Name.first_name }
  let(:description) { Faker::Lorem.paragraph }
  let(:email) { Faker::Internet.email }

  Given { admin_logged_in! }

  context "creating a sponsor" do
    Given do
      click_on "Sponsors"
      click_on "New Sponsor"
    end

    When do
      fill_in "Name", with: name
      fill_in "Description", with: description
      fill_in "Primary contact email", with: email

      click_on "Create Sponsor"
    end

    Then { page.has_content? 'Sponsor was successfully created.' }
    And { page.has_content? name }
    And { page.has_content? description }
    And { page.has_content? email }

    context "then editing that sponsor" do
      When do
        click_on "Edit"

        fill_in "Name", with: "a new name"

        click_on "Update Sponsor"
      end

      Then { page.has_content? 'Sponsor was successfully updated.' }
      And { page.has_content? 'a new name' }
    end

    context "viewing that sponsor on the index" do
      When do
        click_on "Back"
      end 

      Then { page.has_content? name }
      And { page.has_content? email }
    end

    context "deleting that sponsor" do
      When do
        click_on "Back"
        click_on "Destroy"
      end

      Then { page.has_content? 'Sponsor was successfully destroyed.' }

      context "that sponsor no longer shows up on the index" do
        When do
          visit admin_sponsors_path
        end

        Then { !page.has_content? name }
      end
    end
  end
end