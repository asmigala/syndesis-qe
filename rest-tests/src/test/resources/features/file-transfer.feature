# @sustainer: avano@redhat.com

@file-transfer
Feature: File transfer

  Background: Prepare
    Given clean application state

  @integrations-ftp-dropbox
  Scenario: FTP to Dropbox
    Given deploy FTP server
      And delete file "/download/test_dropbox.txt" from FTP
    When create the FTP connection using "ftp" template
      And create Dropbox connection
      And create start FTP download action with values
        | fileName         | directoryName | initialDelay | delay | delete |
        | test_dropbox.txt | download      | 1000         | 500   | true   |
      And create Dropbox upload FINISH action step with file path: "/test.txt"
      And create integration with name: "FTP to Dropbox rest test"
    Then wait for integration with name: "FTP to Dropbox rest test" to become active
    When put "test_dropbox.txt" file with content "Hello from FTP!" in the FTP directory: "download"
    Then check that file with path "/test.txt" exists on Dropbox
      And delete file with path "/test.txt" from Dropbox

  @integrations-s3-ftp
  Scenario: S3 to FTP
    Given deploy FTP server
      And delete file "/upload/test_aws.txt" from FTP
    When create the FTP connection using "ftp" template
      And create sample buckets on S3 with name "syndesis-server-bucket-from"
      And create S3 connection using "syndesis-server-bucket-from" bucket
      And create S3 polling START action step with bucket: "syndesis-server-bucket-from"
      And create finish FTP upload action with values
        | fileName     | directoryName   | fileExist | tempPrefix    | tempFileName     |
        | test_aws.txt | upload          | Override  | copyingprefix | copying_test_out |
      And create integration with name: "S3 to FTP rest test"
    Then wait for integration with name: "S3 to FTP rest test" to become active
    When create a new text file in bucket "syndesis-server-bucket-from" with name "test_aws.txt" and text "Hello from AWS!"
    Then validate that file "test_aws.txt" has been transfered to "/upload" FTP directory

  @integrations-dropbox-s3
  Scenario: Dropbox to S3
    When create Dropbox connection
      And create sample buckets on S3 with name "syndesis-server-bucket-to"
      And create S3 connection using "syndesis-server-bucket-to" bucket
      And create Dropbox download START action step with file path: "/s3"
      And create S3 copy FINISH action step with bucket: "syndesis-server-bucket-to" and filename: "test_dbx.txt"
      And create integration with name: "Dropbox to S3 rest test"
      And upload file with path "/s3/test_dbx.txt" and content "Hello from Dropbox!" on Dropbox
    Then wait for integration with name: "Dropbox to S3 rest test" to become active
      And validate bucket with name "syndesis-server-bucket-to" contains file with name "test_dbx.txt" and text "Hello from Dropbox!"
      And delete file with path "/s3/test_dbx.txt" from Dropbox
