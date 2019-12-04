const password = 'green222'
const usernames = ["lab02", "lab03", "lab04", "lab05", "lab06",
    "lab07", "lab08", "lab09", "lab10", "lab11", "lab12", "lab13", "lab14",
    "lab15", "lab16", "lab17", "lab18", "lab19", "lab20", "lab21", "lab22", "lab23", "lab24"
]
username = "lab01"

module.exports = {
    'Fire Up each CRW': function (browser) {
        browser
            .url('https://codeready-do500-workspaces.apps.example.com/f?name=DO500%20Template&user=admin')
            .waitForElementVisible('body')
            .useXpath()
            .click("//*[@id='zocial-openshift-v3']")
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
            .click('input[value="Submit"]')
            .pause('10000')
            .waitForElementVisible('body', 6000)
            .end()
    }
};