package io.syndesis.qe.steps.settings;

import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.syndesis.qe.pages.settings.SettingsPage;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;

/**
 * Created by sveres on 11/20/17.
 */
public class SettingsSteps {

    private SettingsPage settingsPage = new SettingsPage();

    @Then("^check that settings item \"(\\w+)\" has button \"(\\w+)\"$")
    public void settingsItemHasButton(String itemTitle, String buttonTitle) {
        assertThat(settingsPage.checkButtonOfItem(itemTitle, buttonTitle), is(true));
    }

    @When("^\"(\\w+)\" clicks to the \"(\\w+)\" item \"(\\w+)\" button$")
    public void clickSettingsButton(String userAlias, String itemTitle, String buttonTitle) {
        settingsPage.clickButton(itemTitle, buttonTitle);
    }

    @When("^.*fills? all oauth settings$")
    public void fillAllOAuthSettings() {
        settingsPage.fillAllOAuthSettings();
    }

}
