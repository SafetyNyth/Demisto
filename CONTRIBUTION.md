# Contribution guide

## Description
We build `demisto-sdk` to support python 3.7 and 3.8.

## Getting started

1. [Clone demisto-sdk repository](#1-clone-demisto-sdk-repository)
2. [Install demisto sdk dev environment](#2-install-demisto-sdk-dev-environment)
3. [Pre-commit hooks setup](#3-pre-commit-hooks-setup)
4. [DemistoContentPython Library](#4-demistocontentpython-library)
5. [Develop new command](#5-develop-new-command)
6. [Running unit-tests using tox](#6-running-unit-tests-using-tox)
7. [Push changes to GitHub (External PRs)](#7-push-changes-to-github-relevant-only-for-external-prs)
8. [Review Process](#8-review-process)
9. [Contributor License Agreement (External PRs)](#9-contributor-license-agreement-relevant-only-for-external-prs)

---

### 1. Clone demisto-sdk repository
Perform the following command in the path you want the repository to be cloned:

```shell
git clone https://github.com/demisto/demisto-sdk.git
```

---

### 2. Install demisto sdk dev environment

We will now setup a quick virtualenv in which we will install the `demisto-sdk` version you are currently working on.
This will be used as your testing environment, you do not need to update it again or re-run in any way.

1. Make sure you have python3 installed.

2. Make sure you have pipenv installed.

3. run `pipenv install --dev`

4. To install local version of demisto-sdk, run `pipenv install --keep-outdated -e <path to your demisto-sdk repo>`

5. For further reading about pipenv, you can refer to [pipenv documentation](https://pipenv.pypa.io/en/latest/).

You have now setup the your `demisto-sdk` dev environment!

To activate it simply run: `pipenv shell`.
   * Check that the demisto-sdk installed is your local version by running `demisto-sdk -v` - you will should see something similar to `demisto-sdk 1.X.X.dev`.

To deactivate the virtual environment and return simply run: `exit`.
   * Note that your local `demisto-sdk` version should remain unchanged.

---

### 3. Pre-commit hooks setup
We use are using [pre-commit](https://pre-commit.com/) to run hooks on our build. To use it run:
1. Install hook to be performed as a hook before commit changes - `pre-commit install`
2. Enable auto update of pre-commit hooks - `pre-commit autoupdate`
3. In order to run pre-commit without commit- `pre-commit run -a` (on all files), `pre-commit run` (on staged files)

---

### 4. DemistoContentPython Library
ContentPython is a python library used to interact with Demisto Content repository, high-level abstraction.
For more information read the following [guide](demisto_sdk/commands/common/content/README.md).


---

### 5. Develop new command
1. Create package for your command in the following path: `<repo>/demisto_sdk/commands/<your_new_command>`.
2. Create the following in the above path:
    1.  **CLI arguments parsing** - Add CLI parsing in `<repo>/demisto_sdk/__main__` using [click](https://click.palletsprojects.com/en/7.x/) package.
    2. **commands_module** - The modules suppose to return `0` if **succeed** else `1`, common `print` function can  import from `<repo>/demisto_sdk/commands/common/tools.py`
    3. **unit-tests** -

        1. Unit-tests should be located for each command in the following path-

            ```shell
            <repo>/demisto_sdk/commands/<your_new_command>/tests
            ```

        2. data files tests - Usually its shared data files for all commands which located in:

            ```shell
            <repo>/demisto_sdk/tests/test_files
            ```

            >  (you can use constants for right path in `<repo>/demisto_sdk/tests/constants_test.py`)

        3. check build influence on CircleCI -

            1. Test your functionality on CircleCI build of `Content` repository by changing requirements in `Content` repository:
                1.  Perform the following in `<content_repo>/dev-requirements-py3.txt`:
                    1. Delete `demisto-sdk` requirement.

                    2. Add the following requirement in new line -

                       ```
                        git+https://github.com/demisto/demisto-sdk@<branch>
                       ```

                2. Remove cache using in CircleCI build config, perform the following in file

                    ```shell
                    <content_repo>/.circleci/config.yml
                    ```

                    1. Remove the following string form the following key `restore_cache:`: `-{{ checksum "dev-requirements-py3.txt" }}`

---

### 6. Running unit-tests using tox

[Tox](https://tox.readthedocs.io/en/latest/index.html) aims to automate and standardize testing in Python. It is part of a larger vision of easing the packaging, testing and release process of Python software, we use it in order to check unit-tests on Python versions 3.7 and 3.8.

> If you have one interpreter in your local environment it will skip the missing interpreter and not failed - the 2 versions test will be performed in the CircleCI build.

1. To run all our unit tests we use: `tox` on all envs, optional args:
   * For additional verbosity use: `tox -vv`
   * Run `tox` without verbosity run: `tox -q`
   * Run on a specific environment, you can use: `tox -q -e py37`
2. To run a specific test using pytest run: `pytest -vv tests/{test_file}.py::{TestClass}::{test_function}`

---

### 7. Push changes to GitHub (Relevant only for External PRs)

The Demisto SDK is MIT Licensed and accepts contributions via GitHub pull requests.
If you are a first time GitHub contributor, please look at these links explaining on how to create a Pull Request to a GitHub repo:
* https://guides.github.com/activities/forking/
* https://help.github.com/articles/creating-a-pull-request-from-a-fork/

**Working on your first Pull Request?** You can learn how from this *free* series [How to Contribute to an Open Source Project on GitHub](https://egghead.io/series/how-to-contribute-to-an-open-source-project-on-github)

---

### 8. Review Process
A member of the team will be assigned to review the pull request. Comments will be provided by the team member as the review process progresses.

You will see a few [GitHub Status Checks](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-status-checks) that help validate that your pull request is according to our standards:

* **ci/circleci: build**: We use [CircleCI](https://circleci.com/gh/demisto/demisto-sdk) to run a full build on each commit of your pull request. The build will run our content validation hooks, linting and unit test. We require that the build pass (green build). Follow the `details` link of the status to see the full build UI of CircleCI.
* **LGTM analysis: Python**: We use [LGTM](https://lgtm.com) for continues code analysis. If your PR introduces new LGTM alerts, the LGTM bot will add a comment with links for more details. Usually, these alerts are valid and you should try to fix them. If the alert is a false positive, specify this in a comment of the PR.
* **license/cla**: Status check that all contributors have signed our contributor license agreement (see below).

---

### 9. Contributor License Agreement (Relevant only for External PRs)

Before merging any PRs, we need all contributors to sign a contributor license agreement. By signing a contributor license agreement, we ensure that the community is free to use your contributions.

When you contribute a new pull request, a bot will evaluate whether you have signed the CLA. If required, the bot will comment on the pull request, including a link to accept the agreement. The CLA document is available for review as a [PDF](docs/cla.pdf).

If the `license/cla` status check remains on *Pending*, even though all contributors have accepted the CLA, you can recheck the CLA status by visiting the following link (replace **[PRID]** with the ID of your PR): https://cla-assistant.io/check/demisto/demisto-sdk?pullRequest=[PRID] .

---

If you have a suggestion or an opportunity for improvement that you've identified, please open an issue in this repo.
Enjoy and feel free to reach out to us on the [DFIR Community Slack channel](http://go.demisto.com/join-our-slack-community), or at [info@demisto.com](mailto:info@demisto.com).
