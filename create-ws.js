username = process.env.LAB_NUMBER || "lab01"
password = username

module.exports = {
    'Fire Up each CRW': function (browser) {
        browser
            .url('https://codeready-crw.apps.foo.sandbox925.opentlc.com/f?url=https://raw.githubusercontent.com/eformat/enablement-codereadyworkspaces/2.0/do500-devfile.yaml')
            .waitForElementVisible('body')
            .useXpath()
            .useCss()
            // Login with OCP Creds
            .waitForElementVisible('input[name="username"]', 6000)
            .setValue('input[name="username"]', username)
            .setValue('input[name="password"]', password)
            .click('button[type="submit"]')
            // Approve perms for OCP land
            .waitForElementVisible('input[name="approve"]', 6000)
            .click('input[name="approve"]')
            // Fill in email for CRW nonsense
            .waitForElementVisible('input[name="email"]', 6000)
            .setValue('input[name="email"]', `${username}@redhat.com`)
            .setValue('input[name="firstName"]', username)
            .setValue('input[name="lastName"]', username)
            .click('input[value="Submit"]')
            .pause('10000')
            .waitForElementVisible('body', 6000)
            .end()
    }
};
