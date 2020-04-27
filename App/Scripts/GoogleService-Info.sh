#!/bin/bash

PLIST_FILE=$SRCROOT/App/GoogleService-Info.plist

if [ "${CONFIGURATION}" = "Release" ]; then
    # Replace all variables in release mode, these values are configured in bitrise
    plutil -replace API_KEY -string $FIREBASE_RELEASE_API_KEY $PLIST_FILE
    plutil -replace BUNDLE_ID -string $FIREBASE_RELEASE_BUNDLE_ID $PLIST_FILE
    plutil -replace CLIENT_ID -string $FIREBASE_RELEASE_CLIENT_ID $PLIST_FILE
    plutil -replace DATABASE_URL -string $FIREBASE_RELEASE_DATABASE_URL $PLIST_FILE
    plutil -replace GCM_SENDER_ID -string $FIREBASE_RELEASE_GCM_SENDER_ID $PLIST_FILE
    plutil -replace GOOGLE_APP_ID -string $FIREBASE_RELEASE_GOOGLE_APP_ID $PLIST_FILE
    plutil -replace PROJECT_ID -string $FIREBASE_RELEASE_PROJECT_ID $PLIST_FILE
    plutil -replace REVERSED_CLIENT_ID -string $FIREBASE_RELEASE_REVERSED_CLIENT_ID $PLIST_FILE
    plutil -replace STORAGE_BUCKET -string $FIREBASE_RELEASE_STORAGE_BUCKET $PLIST_FILE
else
    # Set each individual variable if set and not empty when in debug
    if [ -n "${FIREBASE_DEBUG_API_KEY}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_API_KEY $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_BUNDLE_ID}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_BUNDLE_ID $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_DATABASE_URL}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_DATABASE_URL $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_GCM_SENDER_ID}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_GCM_SENDER_ID $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_GOOGLE_APP_ID}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_GOOGLE_APP_ID $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_PROJECT_ID}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_PROJECT_ID $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_REVERSED_CLIENT_ID}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_REVERSED_CLIENT_ID $PLIST_FILE
    fi
    if [ -n "${FIREBASE_DEBUG_STORAGE_BUCKET}" ]; then
        plutil -replace API_KEY -string $FIREBASE_DEBUG_STORAGE_BUCKET $PLIST_FILE
    fi
fi

exit 0
