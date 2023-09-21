require "application_system_test_case"

class NamespacesTest < ApplicationSystemTestCase
  setup do
    @namespace = namespaces(:one)
  end

  test "visiting the index" do
    visit namespaces_url
    assert_selector "h1", text: "Namespaces"
  end

  test "should create namespace" do
    visit namespaces_url
    click_on "New namespace"

    fill_in "Name", with: @namespace.name
    click_on "Create Namespace"

    assert_text "Namespace was successfully created"
    click_on "Back"
  end

  test "should update Namespace" do
    visit namespace_url(@namespace)
    click_on "Edit this namespace", match: :first

    fill_in "Name", with: @namespace.name
    click_on "Update Namespace"

    assert_text "Namespace was successfully updated"
    click_on "Back"
  end

  test "should destroy Namespace" do
    visit namespace_url(@namespace)
    click_on "Destroy this namespace", match: :first

    assert_text "Namespace was successfully destroyed"
  end
end
