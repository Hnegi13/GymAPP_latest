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
  <head>
    <meta name="color-scheme" content="light">
    <meta name="supported-color-schemes" content="light">
  </head>

  <body
    style="
      margin: 0;
      padding: 0;
      background-color: #ffffff !important;
      color-scheme: light;
      font-family: Arial, sans-serif;
    "
  >
                    <div
                      style="
                        max-width: 600px;
                        margin: 30px auto;
                        background-color: #ffffff !important;
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
    color: #333333 !important;
    background-color: #ffffff !important;
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

// subscription email trigger

exports.sendSubscriptionEmail = onDocumentCreated(
    {
      document: "gyms/{gymId}/payments/{paymentId}",
      secrets: [BREVO_API_KEY],
    },
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        console.log("No payment document data found.");
        return;
      }

      const payment = snapshot.data();

      // Send email only for successful payments.
      if (payment.paymentStatus !== "PAID") {
        console.log(
            "Payment is not PAID. No subscription email will be sent.",
        );
        return;
      }

      const gymId = event.params.gymId;

      if (!gymId) {
        console.log("No gymId found.");
        return;
      }

      try {
        // Get gym details
        const gymSnapshot = await admin
            .firestore()
            .collection("gyms")
            .doc(gymId)
            .get();

        if (!gymSnapshot.exists) {
          console.log("Gym document not found:", gymId);
          return;
        }

        const gym = gymSnapshot.data();

        const email = gym.email;
        const ownerName = gym.ownerName || "Gym Owner";
        const gymName = gym.gymName || "Your Gym";

        if (!email) {
          console.log(
              "No email found for gym:",
              gymId,
          );
          return;
        }

        // Payment details
        const plan = payment.plan || "N/A";
        const amount =
                payment.amount !== undefined && payment.amount !== null ?
                    payment.amount :
                    0;
        const paymentId = payment.paymentId || "N/A";
        const receiptNumber =
                payment.receiptNumber || "N/A";

        const paymentDate =
                payment.paymentDate ?
                    payment.paymentDate.toDate() :
                    null;

        const startDate =
                payment.startDate ?
                    payment.startDate.toDate() :
                    null;

        const endDate =
                payment.endDate ?
                    payment.endDate.toDate() :
                    null;

        const formatDate = (date) => {
          if (!date) return "N/A";

          return date.toLocaleDateString(
              "en-IN",
              {
                day: "2-digit",
                month: "short",
                year: "numeric",
              },
          );
        };

        await axios.post(
            "https://api.brevo.com/v3/smtp/email",
            {
              sender: {
                name: APP_CONSTANTS.brevoSenderName,
                email: APP_CONSTANTS.brevoSenderEmail,
              },

              to: [
                {
                  email: email,
                  name: ownerName,
                },
              ],

              subject:
                        "Gym Manager Pro - Subscription Payment Successful",

              htmlContent: `
                <html>
  <head>
    <meta name="color-scheme" content="light">
    <meta name="supported-color-schemes" content="light">
  </head>

  <body
    style="
      margin: 0;
      padding: 0;
      background-color: #ffffff !important;
      color-scheme: light;
      font-family: Arial, sans-serif;
    "
  >

                    <div
                      style="
                        max-width: 600px;
                        margin: 30px auto;
                        background-color: #ffffff !important;
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
                        />
                      </div>

                      <div
  style="
    padding: 10px 30px 30px;
    color: #333333 !important;
    background-color: #ffffff !important;
  "
>

                        <h2 style="text-align: center;">
                          Subscription Payment Successful!
                        </h2>

                        <p>
                          Hi ${ownerName},
                        </p>

                        <p>
                          Your subscription payment for
                          <strong>${gymName}</strong>
                          was successfully completed.
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
                            Subscription Details
                          </h3>

                          <p>
                            <strong>Plan:</strong>
                            ${plan}
                          </p>

                          <p>
                            <strong>Amount Paid:</strong>
                            ₹${amount}
                          </p>

                          <p>
                            <strong>Payment Date:</strong>
                            ${formatDate(paymentDate)}
                          </p>

                          <p>
                            <strong>Plan Start Date:</strong>
                            ${formatDate(startDate)}
                          </p>

                          <p>
                            <strong>Plan End Date:</strong>
                            ${formatDate(endDate)}
                          </p>

                        </div>

                        <div
                          style="
                            background-color: #f8f8f8;
                            padding: 18px;
                            border-radius: 8px;
                            margin: 20px 0;
                          "
                        >

                          <p>
                            <strong>Receipt Number:</strong>
                            ${receiptNumber}
                          </p>

                          <p style="margin-bottom: 0;">
                            <strong>Payment ID:</strong>
                            ${paymentId}
                          </p>

                        </div>

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
            `Subscription email sent successfully to ${email}`,
        );
      } catch (error) {
        console.error(
            "Failed to send subscription email:",
                error.response ?
                    error.response.data :
                    error.message,
        );
      }
    },
);
