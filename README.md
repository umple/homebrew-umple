# How to get Umple available from Homebrew, the package manager for Macs.

## Prerequisite :
- Install Homebrew: https://docs.brew.sh/Installation

## Create a new formula (https://docs.brew.sh/Formula-Cookbook) :
- A formula is a package definition written in Ruby. 
- Follow the Formula Cookbook to create a new formula. 
  - brew create <URL> → creates template brew formula
  - Formulas are installed at: /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula
- Umple formula:
  - To create the formula you need a URL to a zip or tarball. I decided to use a link to umple's latest JAR file because other applications in homebrew based in Java did the same.
  - The description needs to be 80 characters or less
  - The Homepage must be a https link
  - The URL is the link to umple's latest JAR file
  - Version tag is optional since homebrew tries to guess the version from the URL
    - In our case, homebrew got our version wrong so I had to add it
  - Sha256 and license are automatically generated
  - Had to add our dependencies (ant, ant-contrib and openjdk)
  - Bottle:unneeded
    - Without this line, an error will occur when installing and umple will not get installed
    - In the PR, homebrew contributors commented to remove the line
    - Bottle do block is auto generated by the brew's CI when the PR is accepted
  -Install block:
    - Homebrew contributors were very specific on the syntax used to install the application. It is similar for all java based applications available from Homebrew. Originally we were running shell commands through the ruby formula, but that was not accepted.
    - Homebrew packages have specific file structure: <img width="544" alt="Screen Shot 2021-08-19 at 4 48 22 PM" src="https://user-images.githubusercontent.com/31863167/130141861-bfcf8daa-a422-4132-9d2f-b0fd09225250.png">
  - The install method moves a file from the original location to the Pathname
      - https://rubydoc.brew.sh/Pathname.html#install-instance_method
    - The write_jar_script method takes the target jar, a name and writes an exec script that invokes a Java jar
      - https://rubydoc.brew.sh/Pathname.html#write_jar_script-instance_method
  - Test Block:
    - Writes a simple ump file
      - Class X with one attribute 
    - Tests the umple compile command
    - Use the assert_predicate to check if the java and class file were created

## Testing :
- Using the command: brew install umple
  - If installation was successful, umple command will work
- Brew remove umple: will uninstall umple
- Homebrew Packages Are Installed at: /usr/local/Cellar/
- Have to run: brew audit --new <formula> (for new formula) or brew audit --strict <formula> (existing formula)
  - This command will return errors in the formula
- Follow Cookbook (https://docs.brew.sh/Formula-Cookbook) to push to homebrew-core

## Before opening a pull request : 
Homebrew has a checklist that needs to be followed before opening a PR:
- Have you followed the guidelines for contributing? (https://github.com/Homebrew/homebrew-core/blob/HEAD/CONTRIBUTING.md)
- Have you ensured that your commits follow the commit style guide? (https://docs.brew.sh/Formula-Cookbook#commit)
- Have you checked that there aren't other open pull requests for the same formula update/change? (https://github.com/Homebrew/homebrew-core/pulls)
- Have you built your formula locally with brew install --build-from-source <formula>, where <formula> is the name of the formula you're submitting?
- Is your test running fine brew test <formula>, where <formula> is the name of the formula you're submitting?
- Does your build pass brew audit --strict <formula> (after doing brew install --build-from-source <formula>)? If this is a new formula, does it pass brew audit --new <formula>?

How to open a homebrew Pull Request: https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request

## How to update :
- Update URL and sha256
  - URL: get jar link from github release (right click, Copy Link Address)
  - Generate sha256: shasum -a 256 <jar file>
- Bottle do … end block should be left as is (Updated automatically by homebrew)
- Run brew uses <formula> to verify if any other formula is dependant on it
  - If so, run brew reinstall 
  - Link: https://docs.brew.sh/Formula-Cookbook#updating-formulae
- Submit a new version of an existing formula: brew bump-formula-pr
  - Use --help
  - brew bump-formula-pr --url <URL> --sha256 <SHA256> --version <version> umple
