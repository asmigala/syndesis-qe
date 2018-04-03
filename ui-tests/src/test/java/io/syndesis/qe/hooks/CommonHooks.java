package io.syndesis.qe.hooks;

import io.syndesis.qe.utils.SampleDbConnectionManager;
import lombok.extern.slf4j.Slf4j;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;

import com.codeborne.selenide.WebDriverRunner;

import cucumber.api.Scenario;
import cucumber.api.java.After;

@Slf4j
public class CommonHooks {

    @After
    public void afterScreenshot(Scenario scenario) {
        byte[] screenshotAsBytes = ((TakesScreenshot) WebDriverRunner.getWebDriver()).getScreenshotAs(OutputType.BYTES);
        scenario.embed(screenshotAsBytes, "image/png");
    }

    //we can close it after specific scenarios, but it will do nothing if connection == null and I do not know exactly all scenarios which opens DB connection
    //@After("@scenario1,@scenario2")
    @After
    public void closeDBConnection() {
        log.debug("Closing DB connection if it exists");
        SampleDbConnectionManager.closeConnection();
    }
}
