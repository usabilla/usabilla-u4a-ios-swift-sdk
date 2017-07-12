# Guide to Mobile Campaigns

## Introduction
Version 4 of the Usabilla for Apps Swift SDK introduces the new campaigns functionality.
This guide describes the Campaigns feature and all the steps necessary to work with it.

In the Usabilla for Apps Platform, we define a campaign as a proactive survey targeted to a specific set of users.

Being able to run campaigns in your mobile app is great because it allows you to collect more specific insights from your targeted users. What is even better is that creating new and managing existing campaigns can be done without the need for a new release of your app. Everything can be managed from the Usabilla web interface.

You can run as many campaigns as you like and target them to be triggered when a specific set of targeting options is met. The survey that is displayed to the user can be configured just like you are used to with the existing feedback forms in your app.

## Features

The most important aspect of running a mobile campaign are 'Events'. Events are custom triggers that are configured by your app developer. When a pre-defined event occurs it will allow you to trigger a campaign. A good example of an event is a successful purchase by a user in your app. Or the scenario in which a user does not complete their purchase.

### Targeting options

- Target specific App(s), it is possible to target a campaign to more than one app (e.g. iOS Production App, iOS Beta App)
- Target a specific event (e.g. purchase complete)
- Target the frequency of that event occurring (e.g. 3 times)
- Specify the percentage of users for whom the campaign should be triggered (e.g. 10%)

Note: A campaign will never be triggered for the same user more than once.

### Managing an existing campaign

After you create a new campaign in the Usabilla for Apps [Campaign Editor](https://app.usabilla.com/member/live/apps/campaigns/add) you can start collecting results. By default, new campaigns are marked as inactive. From the Usabilla web interface, on the Usabilla for Apps [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/), you can activate a campaign. Once you have received a satisfying amount of responses you can deactivate it.

At any time you can update the survey content of your campaign (e.g. questions). Keep in mind that the changes you make to an existing campaign might affect the integrity of the data you collect (different responses before and after a change).

Furthermore, you can also change the targeting options of a campaign. Keep in mind that updating the targeting options of an active campaign will reset any progression previously made on the user's device.

### Campaign results

Aggregated campaign results are available for download from the [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/). Here you download the results per campaign, in the CSV format.

Campaign results will contain the answers that your users provided. The campaign feature collects campaign results page by page. This means that even if the user abandons the campaign halfway through, you will still collect valuable insights. When a user navigates to a new page, then the results of the previous page are submitted to Usabilla. Besides the results showing the answers to your questions, campaigns will always contain metadata from the device. 

As for campaign results. Please note that editing the form of an existing campaign will affect the aggregated campaign results:

- Adding new questions to a form will add an additional column to the CSV file
- Removing questions from an existing form will keep the column in the CSV file and it displays previously collected results
- Replacing the question type with a different question is also possible. When you give the same 'name' in the Usabilla for Apps Campaign Editor, then results are represented in the same column. 

## Setting up the SDK

### Initialize the SDK

A small number of services must be started before the campaign functionality becomes accessible.
To do so, the `load(appId: String)` method in the SDK has to be called first.
This method takes an appId as a parameter. An `appId` is a UUID generated in the web interface of the [Campaign Editor](https://app.usabilla.com/member/live/apps/campaigns/add).

This will allow the SDK to be aware of the "hosting app" it is running in, and fetch the campaigns associated with this app.
Once this method is called, all **active** campaigns associated with the `appId` will begin to run.

The method returns a boolean that specifies whether or not the initialization was successful.

**To reduce the network usage the method only checks if the appId passed as a parameter is a valid UUID. It does not check whether or not that it actually exists in the Usabilla database.**

### Targeting - Sending events to the SDK

Campaigns are triggered when a series of events, defined in the Usabilla for Apps Campaign Editor, is complete.
Just like most analytics tools, it is possible to define events tailored to your app and distribute them freely.

An event is just a string containing the name of an event.
To send an event to the SDK, use `sendEvent(event: String)`.

### Campaign Toggling

Sometimes the user of your app is in the middle of a delicate process and should not be disturbed.
To make sure no campaigns trigger at an inappropriate moment, you can set the boolean property `canDisplayCampaigns` of `UsabillaFeedbackForm` to suit your needs.

Setting it to `true` will allow the SDK to display any campaign when it triggers.
Setting it to `false` will prevent any campaign from being displayed.

**If a campaign triggers while `canDisplayCampaigns` is `false`, it won't be displayed nor delayed: That event instance will be lost.**

By default, `canDisplayCampaigns` is set to `true`.

There is an important reason why a campaign is not delayed for display if the `canDisplayCampaigns` was `false` when the campaign is triggered and later changes to `true`. The reasoning is that displaying a campaign should happen when the targeted event occurs. We can assume that the events configured in your application are also triggered at a proper time in order to display it to your users.
