const {setGlobalOptions} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");
const axios = require("axios");
const APP_CONSTANTS = require("./app_constants");

admin.initializeApp();

setGlobalOptions({
  maxInstances: 10,
});

const BREVO_API_KEY = defineSecret("BREVO_API_KEY");

exports.sendRegistrationEmail = onDocumentCreated(
    {
      document: "gyms/{gymId}",
      secrets: [BREVO_API_KEY],
    },
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        console.log("No gym document data found.");
        return;
      }

      const gym = snapshot.data();

      const email = gym.email;
      const ownerName = gym.ownerName;
      const gymName = gym.gymName;

      if (!email) {
        console.log("No email found for gym:", event.params.gymId);
        return;
      }

      try {
        await axios.post(
            "https://api.brevo.com/v3/smtp/email",
            {
              sender: {
                name: "Gym Manager Pro",
                email: APP_CONSTANTS.brevoSenderEmail,
              },

              to: [
                {
                  email: email,
                  name: ownerName || "Gym Owner",
                },
              ],

              subject: "Welcome to Gym Manager Pro",

              htmlContent: `
                <html>
                  <body
                    style="
                      margin: 0;
                      padding: 0;
                      background-color: #f5f6f8;
                      font-family: Arial, sans-serif;
                    "
                  >
                    <div
                      style="
                        max-width: 600px;
                        margin: 30px auto;
                        background-color: #ffffff;
                        border-radius: 12px;
                        overflow: hidden;
                      "
                    >
                      <div
                        style="
                          text-align: center;
                          padding: 30px 20px 15px;
                        "
                      >
                        <img
                          src="${APP_CONSTANTS.emailLogoUrl}"
                          alt="Gym Manager Pro"
                          style="
                            width: 120px;
                            height: auto;
                          "
                        >
                      </div>

                      <div
                        style="
                          padding: 10px 30px 30px;
                          color: #333333;
                        "
                      >
                        <h2 style="text-align: center;">
                          Welcome to Gym Manager Pro!
                        </h2>

                        <p>
                          Hi ${ownerName || "Gym Owner"},
                        </p>

                        <p>
                          Your gym
                          <strong>${gymName || "N/A"}</strong>
                          has been successfully registered with
                          Gym Manager Pro.
                        </p>

                        <div
                          style="
                            background-color: #f0f7ff;
                            padding: 18px;
                            border-radius: 8px;
                            margin: 20px 0;
                          "
                        >
                          <h3 style="margin-top: 0;">
                            🎉 Your 5-day free trial has started!
                          </h3>

                          <p style="margin-bottom: 0;">
                            You can explore Gym Manager Pro during
                            your free trial. After your trial ends,
                            you'll need to choose a subscription plan
                            to continue using the service.
                          </p>
                        </div>

                        <h3>What you'll get with a subscription</h3>

                        <ul>
                          <li>Member Management</li>
                          <li>Attendance Tracking</li>
                          <li>Payment Management</li>
                          <li>Membership Plans</li>
                          <li>Dashboard Analytics</li>
                          <li>Expiry Notifications</li>
                          <li>Export Members</li>
                        </ul>

                        <p>
                          Thank you for choosing
                          <strong>Gym Manager Pro</strong>.
                        </p>

                        <p style="margin-top: 25px;">
                          <strong>Manage • Track • Grow</strong>
                        </p>

                        <p>
                          Regards,<br>
                          Gym Manager Pro Team
                        </p>
                      </div>
                    </div>
                  </body>
                </html>
              `,
            },
            {
              headers: {
                "api-key": BREVO_API_KEY.value(),
                "Content-Type": "application/json",
              },
            },
        );

        console.log(
            `Registration email sent successfully to ${email}`,
        );
      } catch (error) {
        console.error(
            "Failed to send registration email:",
                error.response ?
                    error.response.data :
                    error.message,
        );
      }
    },
);
