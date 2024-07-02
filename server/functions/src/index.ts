import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const checkVersion = functions.https.onRequest((req, res) => {
    const currentVersion = "0.2";
    const clientVersion = req.body.clientVersion;

    if (!clientVersion) {
        res.status(400).send('clientVersion is required');
        return;
    }

    const isLatestVersion = currentVersion === clientVersion;
    res.status(200).json(isLatestVersion);
});
