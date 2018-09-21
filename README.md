# AMI Pipeline with Packer and CodePipeline
This is a small demo showing the possibilities for creating and updating an AMI using [Packer](https://www.packer.io/), [CodePipeline](https://aws.amazon.com/codepipeline/), [CodeBuild](https://aws.amazon.com/codebuild/), [Chef](https://www.chef.io), and tested using Chef's [InSpec](https://www.chef.io/inspec/).

# Deployment
Deploy the CloudFormation template `cfn/pipeline.yml`. You'll need permissions on CloudFormation, EC2, IAM, S3, CodePipeline and CodeBuild. The following parameters are required:

* A GitHub username or org name (e.g. ht<span>tps://github</span>.com/**stelligent**)
* A repository name
* The branch (e.g. `master`) 
* A [GitHub OAuth Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) with at least read access to the repository

# How it works
Once the CloudFormation stack has deployed, the Pipeline will build a simple AMI with Nginx and a basic HTML file using Chef.

The pipeline accomplishes this by running the following tasks:

1. Pull the latest version of the code from the repo/branch
2. Validate the Packer template
    * `packer/ami.json`
3. Build the AMI via Packer and Chef
    * `packer/ami.json`
    * `packer/ami_params.json`
    * `cookbooks/nginx`
4. Launch a test instance with the newly built AMI 
    * `cfn/test-instance.yml`
5. Test the AMI using InSpec
    * `test/inspec/test.rb`
6. Delete the test instance
7. Publish the AMI by saving the AMI ID in an [SSM Parameter](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) called `/packerdemo/packer_ami_pipeline/LatestAMI`

# Structure
* `buildscripts/` Scripts used to configure test instance
* `buildspec/` CodeBuild BuildSpec YML files
* `cfn/` CloudFormation templates
* `cookbooks/` Chef Cookbooks used to configure Image
* `packer/` Packer templates and parameter files
* `test/` InSpec tests

