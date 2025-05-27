# PurrfectPedia – Software Requirements Specification (SRS)

## List of App Screens

* **Sign-In Screen** (Google Sign-In)
* **User Profile Screen**
* **Breed Encyclopedia Screen** (Breed List)
* **Breed Detail Screen**
* **Favorites Screen**
* **Breed Comparison Screen** (Breed Selection)
* **Comparison Result Screen**
* **Cat Recognition Screen** (Photo Input)
* **Recognition Result Screen**
* **Cat Fact Hub Screen** (Daily Facts)
* **Admin Dashboard** (Admin-only)
* **Admin Breed Management Screen** (Admin-only)
* **Admin Breed Edit Screen** (Admin-only)
* **Admin Fact Management Screen** (Admin-only)
* **Admin Fact Edit Screen** (Admin-only)
* **Admin Recognition Logs Screen** (Admin-only)

*(Note: Admin-only screens are accessible only to users with administrator privileges.)*

---

## Sign-In Screen (Google Sign-In)

**Purpose:** Allow the user to authenticate via Google, enabling personalized features (e.g. syncing favorites across devices and accessing admin functions). This screen establishes the user’s identity using Firebase Authentication with Google as the provider.

**Inputs:**

* **Google Sign-In Button:** User taps the “Sign in with Google” button to initiate OAuth login through Google.
* **Cancel/Back Action:** The user can navigate away (e.g. using a back button) if they choose not to sign in.

**Outputs:**

* **Google Sign-In UI:** The screen displays a branded Google sign-in button (per Google’s UI guidelines).
* **Status/Errors:** If sign-in fails, an error message is displayed (e.g. “Sign-in failed, please check your connection”). Otherwise, on success, the screen transitions away.
* **Loading Indicator:** A transient indicator (spinner) may be shown while the Google sign-in flow is in progress.

**Navigation:**

* **Entry:** This screen is shown on app launch if the user is not already signed in, or when the user selects a “Sign In” option (for example, from a Profile screen if logged out).
* **Exit:** On successful sign-in, the user is redirected to the main app (e.g. Breed Encyclopedia or Profile screen). If the user presses back or cancels, they return to browsing as a guest (with limited functionality). Admin users, after signing in, will have access to admin screens.

**Functionality:**

* Initiates the Google sign-in flow via FirebaseAuth when the user taps the button. This triggers Google’s OAuth process (account picker, permissions, etc.).
* Receives the authentication response and signs the user into Firebase. On success, the app obtains the user’s profile info (name, email, profile photo URL) from the Google account.
* Persists the logged-in state using Firebase so the user remains logged in across app restarts (unless they sign out).
* If the user is an admin (determined by their email or a flag in the database), the app unlocks access to admin panel screens (e.g., an “Admin Dashboard” button becomes visible in their Profile).
* **Data Validation:** Minimal on the client side (the email/password is handled by Google). Ensures the Firebase credential is valid.
* **Error Handling:** If sign-in fails (e.g. network down or user cancels), an error message is shown and the user remains logged out. The user can retry. If the device has no internet connection, the app should inform the user that internet is required for login.
* **Offline Notes:** Google authentication **cannot** be done offline (Firebase Auth requires an internet connection to verify credentials). If the user was previously signed in and goes offline, they remain logged in with cached credentials, but cannot re-authenticate or switch accounts while offline. The Sign-In screen should be inaccessible offline (or display a message that login requires connectivity).

## User Profile Screen

**Purpose:** Display the authenticated user’s profile information and provide account-related actions. This screen lets the user view their details, access favorites, and sign out. If the user has admin privileges, it also serves as an entry point to admin functions.

**Inputs:**

* **Sign Out Button:** User can tap a “Sign Out” action to log out of their account.
* **Favorites Shortcut:** User can tap a section or button to view their favorited breeds (navigates to Favorites Screen).
* **Admin Panel Shortcut:** (Visible to admin users only) User taps an “Admin Dashboard” button to access admin screens.
* **General Navigation:** The user may use bottom navigation or a menu to reach other main screens from here (e.g., going to Facts or Breed list).

**Outputs:**

* **User Info Display:** Shows the user’s name, profile photo (if available), and email as retrieved from Google.
* **Favorites Summary:** May show a count of favorite breeds and/or a preview list of favorites (e.g., a few favorited breed names or images) to encourage navigation to favorites.
* **Admin Indicator:** If the user is an admin, the UI indicates this (for example, “Admin Account”) and shows admin options. Regular users will not see admin options.
* **UI Controls:** Sign-out button, and navigation buttons or tabs for other sections of the app (depending on app layout).

**Navigation:**

* **Entry:** Accessible from main app navigation (e.g., via a “Profile” tab or menu item) once the user is logged in. If a not-logged-in user somehow accesses this screen, they will be redirected to the Sign-In Screen or shown only a prompt to sign in.
* **Exit:**

  * If “Favorites” is selected, navigates to the Favorites Screen.
  * If “Admin Dashboard” is selected (admins only), navigates to the Admin Dashboard.
  * If “Sign Out” is selected, the app signs out and typically navigates back to the Sign-In Screen (or to a state where user-specific features are hidden).
  * The user can also switch to other main screens (e.g., Facts or Breed list) via the app’s navigation without leaving the logged-in state.

**Functionality:**

* Displays current user profile data from FirebaseAuth. This data is read from the cached user session (no extra network call needed for basic profile info after login).
* **Favorites Access:** The screen provides quick navigation to Favorites. It may display the number of favorites and update it in real-time if favorites change (e.g., if user adds/removes favorites on Breed screens, the count here updates via state or stream from the database).
* **Sign Out Process:** If user taps “Sign Out,” the app signs out via FirebaseAuth (clearing the session). Locally stored user data (like cached favorites or profile photo) remains but will now be associated with a logged-out state. After sign-out, user-specific features are disabled until next login.
* **Admin Access:** For admin users, tapping “Admin Dashboard” verifies the user’s admin status (if not already known) and opens the admin interface. Non-admin users will not have this option (and any attempt to navigate to admin routes will be blocked).
* **Data Validation:** Ensures that user data displayed is up-to-date (fetch fresh profile info if needed, e.g., if profile image changed on Google’s side – though usually FirebaseAuth provides the current info).
* **Error Handling:** If for some reason user data cannot be retrieved, the screen will show placeholders or ask the user to re-login. If sign-out fails (very rare, typically offline scenario), it will inform the user and allow retry or force sign-out by clearing local session.
* **Offline Notes:** Viewing the Profile is possible offline using cached data (name, email, photo cached from login). The user can sign out while offline (this will clear local credentials immediately). However, they will not be able to sign back in until online (the app should warn that re-authentication is not available offline). Favorites shown on this screen (count or list snippet) can be loaded from cached data if available, thanks to Firestore’s offline persistence. Admin navigation requires that the necessary data be cached or will otherwise show stale data until online.

## Breed Encyclopedia Screen (Breed List)

**Purpose:** Present a comprehensive list of cat breeds for users to browse and search. This is the main encyclopedia view, allowing users to learn about different breeds and select one to see detailed information. The app includes information on dozens of cat breeds (approximately 60+ breeds covering all major recognized breeds).

**Inputs:**

* **Breed List Scrolling:** The user scrolls through the list of breeds to browse.
* **Search Query:** The user can enter text into a search bar to filter breeds by name (e.g., typing “Siamese” filters the list to Siamese and related breeds).
* **Breed Selection:** The user taps on a specific breed entry from the list to view its details on the Breed Detail Screen.
* **Pull-to-Refresh:** (Optional) The user can perform a pull-down gesture to refresh the breed data (in case of updates or to re-fetch if an error occurred).

**Outputs:**

* **List of Breeds:** An alphabetically ordered list of breed names, each item often accompanied by a thumbnail image of the cat (if available) and possibly a one-line summary or origin (for quick scanning). For example, an item might show “Siamese – Origin: Thailand” in the list.
* **Search Bar:** A text input at the top for searching breed names. As the user types, the list filters to matching breeds.
* **Loading/Empty State:** If data is being fetched initially, a loading indicator is shown. If no breeds are found (e.g., search yields no results), an “No breeds found” message is displayed.
* **Cached Indicator:** (Optional) If viewing cached data offline, the UI might indicate that the data may be stale or show an “offline mode” badge.

**Navigation:**

* **Entry:** This is typically one of the primary screens accessible via bottom navigation or as the default home screen after login. The user can reach it directly upon launching the app (after any sign-in) or by selecting “Encyclopedia” from the nav menu.
* **Exit:**

  * When a breed is tapped, navigates to the **Breed Detail Screen** for that breed.
  * The user can switch to other main sections (Facts, Recognition, Profile, etc.) via the navigation bar without “exiting” in a traditional sense.
  * Back navigation (if using stack navigation) would exit the app if this is the root screen, or simply remain on this screen as it is a top-level screen.

**Functionality:**

* **Data Retrieval:** On screen load, the app fetches the full list of breeds from the Firebase backend (e.g., Firestore). This includes each breed’s basic info needed for listing (name, possibly thumbnail URL, and any snippet). Data is cached locally so that once fetched, it can be accessed offline. If the data was previously loaded, the app may use the cached data instantly and then refresh in background to get any updates.
* **Search/Filter:** As the user types in the search bar, the list dynamically filters to breeds whose name (or other attributes) match the query. This filtering is done client-side on the loaded dataset for responsiveness. If the list is very large (which at \~60 breeds it is not), a more complex query could be used, but here local filter is fine.
* **Breed Item Selection:** When the user selects a breed, the app opens the Breed Detail Screen, passing the selected breed’s ID or data.
* **Favorites Indication:** Optionally, breeds that the user has favorited could be indicated in the list (e.g., a small star icon on the item). The user might even be able to favorite/unfavorite directly from the list (though primary flow is through detail screen). If direct favoriting in list is allowed, tapping a favorite icon on a list item will toggle that breed in the user’s favorites (updating the database accordingly).
* **Pull-to-Refresh:** If implemented, pulling down will force reloading the breed list from the server, updating local cache. This helps the user get new data if the admin added or changed breed info.
* **Data Validation:** Ensures each breed entry has the required fields (at least a name). If any critical data is missing or malformed, that entry can be skipped or marked as error. (For example, if an image fails to load, a placeholder image is shown.) Duplicate breed names are not expected (and ideally prevented in admin tools).
* **Error Handling:** If the breed list fails to load (e.g., no internet on first use), the screen shows an error message (“Unable to load breeds. Please check your connection.”) and possibly a retry button. If cached data exists from a previous session, the app will display that cached data with a notice that it may be outdated. Search will still operate on whatever data is present.
* **Offline Notes:** The breed list can be viewed offline after the first successful data load. Thanks to Firebase’s offline persistence, the app caches the breed data so the user can scroll and search even without connectivity. If the user has never loaded the data and is offline, the screen will be empty with an error or prompt to connect. While offline, search will work on the cached dataset. The user cannot get new updates or breeds until back online, but they can still navigate to details of any breed that was cached.

## Breed Detail Screen

**Purpose:** Provide in-depth information about a specific cat breed. When a user selects a breed from the list (or via another feature), this screen shows all pertinent details about that breed, allowing the user to learn about its characteristics. Users can also favorite the breed for quick access later or compare it with another breed.

**Inputs:**

* **View Favorite Toggle:** The user can tap a “Favorite” icon (e.g., a star or heart) to add or remove this breed from their favorites list.
* **Compare Action:** The user may tap a “Compare” button (if provided on this screen) to initiate comparing this breed with another. This action would navigate to the Breed Comparison Screen with this breed pre-selected as one of the comparison options.
* **Navigation Gestures:** The user can swipe back or tap a back arrow to return to the previous screen (Breed List or wherever they came from). They might also swipe left/right if the app supports moving to adjacent breeds (not required, but some encyclopedias allow swiping to next breed; this is optional functionality).
* **External Link (Optional):** If available, tapping a “Learn more” link (e.g., Wikipedia link for the breed) will open the link in a browser. This is optional and for extended info outside the app.

**Outputs:**

* **Breed Name:** The name of the breed is prominently displayed (often as the screen title).
* **Breed Image:** A representative image of the breed (fetched from the database or storage) is shown at the top. If multiple images are stored, possibly a carousel or gallery could be present, but at minimum one image is shown.
* **Description:** A textual description of the breed covering its history, appearance, and temperament. This may be a few paragraphs of informative text.
* **Attributes/Traits:** Key breed-specific attributes are listed. This includes:

  * **Origin:** Country or region of origin.
  * **Life Span:** Expected life span (e.g., “12 – 15 years”).
  * **Temperament:** A summary of the breed’s typical temperament (e.g., “Affectionate, Playful, Intelligent”).
  * **Physical Characteristics:** Such as size/weight (if included in data), coat length/type, grooming needs.
  * **Behavioral Ratings:** Various traits with ratings (usually on a scale of 1-5 or descriptive). For example: adaptability, affection level, child-friendliness, grooming requirement level, intelligence, health issues tendency, social needs, stranger friendliness, etc. These can be displayed as labeled values or via icons (e.g., 4/5 stars for Intelligence).
* **Favorite Indicator:** The favorite icon reflecting the current state – filled (if this breed is already in user’s favorites) or empty if not. This gives visual feedback and toggles when tapped.
* **Compare Button:** A button or icon to start a comparison, labeled something like “Compare with another breed.”
* **Additional Info:** Optionally, fields like **Alternative Names**, **Breed Group/Category**, **Year of origin**, or **Wikipedia link** might be shown if available in the data. If the admin has provided a URL to more info, an external link can be presented.

**Navigation:**

* **Entry:** This screen is reached when the user selects a breed from the Breed List, from Favorites, from a search result, or via other features (e.g., tapping a breed name in Recognition Result or in Comparison Result). The app passes the breed identifier or object to load the correct details.
* **Exit:**

  * Back navigation returns the user to the source screen (e.g., back to the list they scrolled, or back to Favorites, etc.).
  * If the user taps “Compare,” the app navigates to the Breed Comparison Screen (selection step) with this breed pre-loaded as Breed A (the user will then choose Breed B to compare).
  * If the user taps an external link (like Wikipedia), the app opens the device’s web browser (leaving the app for that action).
  * If the user navigates via bottom menu to another main section (Facts, etc.), the detail screen may be left in the background (the user can return via back).
* **Internal Navigation:** The user could potentially tap on any related items within the details (for example, if temperament mentions another breed or category, though that’s unlikely in this context). Generally, it’s a final detail view.

**Functionality:**

* **Data Loading:** The screen loads the full breed details. If the navigation passed a complete breed object (from Breed List cache), it will display those details immediately. If not (e.g., user came from a deep link with just an ID), the app queries the database for that breed’s details. Data is likely stored in Firestore (e.g., a “breeds” collection) and includes all the fields listed above. This data may also be cached from the initial list fetch.
* **Display Info:** All relevant fields are displayed in a clean, scrollable layout. Long text (description) is scrollable. Trait ratings might be displayed as horizontal bars or star icons. For example, “Affection Level: ★★★★☆ (4/5)”. The app uses a consistent format for these attributes, possibly icons with tooltips for clarity.
* **Favorite/Unfavorite:** When the user taps the favorite icon:

  * If the user is logged in: the app updates their favorites. This involves writing to a Firebase location (for example, adding this breed’s ID to a “favorites” list under the user’s profile in Firestore). The UI immediately toggles to show the updated state (highlighted icon for favorited). If the write fails (network issue), it may revert and show a message. The change is synced to the cloud so it’s available on other devices the user logs into.
  * If the user is not logged in: tapping favorite prompts the user to sign in (since cross-device sync requires an account). The app might show a dialog: “Sign in to save favorites across devices.” The user can choose to sign in (navigating to Sign-In Screen) or continue without saving (perhaps the app could allow local-only favorites for guest, but by design we assume favorites are tied to account for persistence). If operating in guest mode with local favorites, the app would store the favorite in local storage; however, this is a simplified SRS assumption that sign-in is required for favorites to persist.
* **Compare Action:** If the user taps “Compare with another breed,” the app navigates to the Breed Comparison selection screen. It may pass along the current breed as the first selection. For example, on the Comparison Screen, Breed A will already be set to this breed, and the user will just choose Breed B. This is a convenience to streamline comparisons from a breed page.
* **Offline Support:** If the user had loaded this breed info previously, it will be available offline via cache. The detail screen can show cached data while offline. Images: if the image was viewed before, it might be cached in the image cache; otherwise, a placeholder will appear if offline. If the user tries to favorite while offline, the app (with Firestore offline persistence) will queue that favorite addition and sync it when back online. The UI should reflect the favorite immediately (optimistic update) and handle sync later. If the user is offline and not logged in, they cannot perform a cloud-backed favorite (though a local favorite could be toggled, it would remain local unless later synced upon login).
* **Data Validation:** The app should ensure required breed fields are present. For instance, breed name and description are essential – if missing, an error or placeholder (“Information not available”) is shown. Numeric trait fields should be within expected ranges (1–5 if they are ratings). If any field is null or undefined in the database, the app handles it gracefully (e.g., skip or label as “Unknown”).
* **Error Handling:** If the breed data fails to load (due to a network error and no cache), the screen will show an error message or dialog. The user can tap retry to attempt loading again. If a portion of data fails (e.g. image fails to download), the app shows a broken image icon or keeps a placeholder, but still displays text info. On a favorite toggle failure, an error snackbar might say “Could not save favorite. Check your connection.” Similarly, if unfavorite fails, it might revert the icon to favorited state.
* **Navigation Constraints:** Swiping back or using back button will take the user to where they came from. The app should preserve scroll position on the Breed List if returning, so the user doesn’t lose their place. Also, if the user came from Favorites, it should return there. These are UI/UX details to ensure a smooth experience.

## Favorites Screen

**Purpose:** Allow the user to view and manage their favorite breeds in one place. This screen lists all breeds that the user has marked as favorite, enabling quick access to those breed details. It essentially filters the breed list to just the user’s saved items.

**Inputs:**

* **Select Favorite Breed:** The user taps on any breed in their favorites list to view its details (navigates to Breed Detail Screen).
* **Remove Favorite:** The user can remove a breed from favorites. This could be done by tapping a “filled star” icon next to the breed (toggling it off), or via a swipe action (e.g., swipe left to reveal a “Remove” option), or a long-press context menu. The exact UI can be any of these; the key input is the user indicating they want to unfavorite an item.
* **Pull-to-Refresh:** Optionally, the user can refresh the list (though it should update in real-time via database listeners if the data changes on another device or by admin removal).

**Outputs:**

* **List of Favorite Breeds:** A list (similar in format to the Breed List) but only containing breeds the user marked as favorite. Each item might show the breed name and a small image. They might also show a remove icon (like a filled star that can be tapped to remove).
* **Empty State Message:** If the user has no favorites, the screen displays a friendly message like “You haven’t added any favorite breeds yet.” Possibly accompanied by a prompt to browse breeds to add some.
* **Confirmation Prompt:** If the app uses a swipe or delete button, it might show a confirmation “Remove from favorites?” to avoid accidental removal (this could be optional).
* **Navigation UI:** Standard navigation elements (back button if this is not a tab, or the tab bar if using tabs stays visible). Possibly a title like “Your Favorites”.

**Navigation:**

* **Entry:** The user can access this screen by selecting “Favorites” from the Profile screen or via a direct tab/menu item if the app design includes one. Typically, the profile screen will have a “Favorites” option that leads here. It requires the user to be logged in (if a guest tries to access, prompt login).
* **Exit:**

  * Tapping a breed goes to Breed Detail Screen (and from there, back goes back to Favorites).
  * The user can use the back button to return to the Profile or wherever they came from. If Favorites is a top-level tab, switching tabs will leave this screen context.
  * After removing favorites, the user stays on this screen; if the list becomes empty, the empty state is shown.
* **Cross-Navigation:** The user may also navigate to comparison or recognition from here via the main nav if present, but that’s outside this screen’s direct scope.

**Functionality:**

* **Data Loading:** When the screen opens, it queries the user’s favorites from the backend. For example, there might be a “favorites” array stored with the user’s profile document (containing breed IDs), or a separate “favorites” collection keyed by user. The app will retrieve the list of favorite breed IDs and then fetch the breed details for those IDs (if not already cached). This could be done with a single query if the data model stores favorites as references, or multiple lookups if needed. The result is the set of breed objects to display. The app may also use real-time listeners to keep this list updated (so if on another device the user favorites something, it appears here, or if an admin deletes a breed, it gets removed).
* **Display Favorites:** The breeds are displayed in a scrollable list. If images are available (and cached or quick to fetch), they are shown. If not, the app might load them asynchronously. The list might be sorted alphabetically or by the time added (design choice; alphabetical is user-friendly to find, whereas by added date shows recent favorites first). Here, alphabetical might make sense, or by added date if we want to emphasize new favorites. We will assume alphabetical unless otherwise specified.
* **Remove Favorite:** If the user taps the star icon or remove action on a breed:

  * The app will update the favorites in the database (remove that breed’s ID from the user’s favorites list in Firestore). This update is done in real-time. On success, the UI immediately removes the item from the list.
  * If the removal fails (e.g., offline), the app will either: (a) immediately reflect removal locally and rely on offline sync to update the server when possible (optimistic removal with Firestore caching), or (b) show an error and keep the item. Using Firestore offline, removal can be queued – the item can be removed locally and Firestore will sync the change when back online. The app should handle the case where the user is offline gracefully by possibly informing them that changes will sync later.
* **Favorites Sync:** Because the user is logged in, their favorites are stored in cloud and thus synced to any device they log in from. The screen should reflect the current state of favorites from the database. If the user adds/removes favorites on another screen (breed detail), this screen can either refresh when it comes into view or be actively listening to changes in the favorites list to update instantly.
* **Data Validation:** Ensure that each favorite breed ID corresponds to a valid breed document. If a breed was removed from the database by an admin, the app should handle that – e.g., the favorites query might return an ID that no longer has an associated breed. In such a case, the app can silently drop it or display it as “\[Breed removed]” and give the user an option to remove it. (Better is to remove automatically to avoid broken links.)
* **Error Handling:** If the favorites list fails to load (network error and no cache), show a message: “Unable to load favorites. Please check your connection.” If partial data loads (e.g., got the list of IDs but some breed details failed to fetch), show the known ones and perhaps placeholders for others or skip them. If removing a favorite fails, show an error message: “Could not remove favorite. Try again.” If the user is not logged in (which shouldn’t happen if they reached here normally), the app will prompt login and not attempt to load favorites (since favorites are account-based).
* **Offline Notes:** The favorites can be viewed offline if the data was previously synced. Because breed details are likely cached from earlier browsing, the app can display those favorite breeds from cache offline. Firestore’s cache would also have the list of favorite IDs from the user’s last online session. So, offline, the screen can still show the list (maybe with a note “Offline mode”). Removing a favorite offline will queue the removal to sync later, as described. If the user tries to favorite or unfavorite a breed offline and then immediately goes to the Favorites screen, the changes will reflect locally (due to offline persistence) and update on server when connected. In summary, offline usage is supported for viewing and tentative modifications, but any changes sync when back online. The user should be aware that if they reinstall or use a new device offline, they won’t have the favorites until they connect.

## Breed Comparison Screen (Selection)

**Purpose:** Allow the user to select two cat breeds to compare side-by-side. This screen collects the user’s choices (Breed A and Breed B) and then leads to a comparison result. It guides the user through picking the two breeds from the full list of breeds.

**Inputs:**

* **Breed A Selection:** The user chooses the first breed to compare. This could be implemented as a dropdown menu, an autocomplete search field, or a navigation to a breed list picker. For example, tapping a “Select Breed 1” field could open a list or search dialog of breeds to pick from.
* **Breed B Selection:** Similarly, the user chooses the second breed. The UI should prevent selecting the same breed twice (if the user tries, it should either disallow or show a validation error).
* **Pre-selection (optional):** If the user came from a Breed Detail “Compare” action, Breed A might already be filled with that breed, so the user only needs to pick Breed B. They can change Breed A as well if desired.
* **Compare Action:** Once two distinct breeds are selected, the user taps a “Compare” button to proceed. This is effectively a submission of the two choices to generate the comparison.
* **Cancel/Back:** The user can back out without comparing (e.g., pressing back returns to where they came from, such as a Breed Detail or main menu).

**Outputs:**

* **Breed Selection Fields:** Two input fields labeled for Breed 1 and Breed 2. Each might show the currently selected breed name (or “Select a breed” placeholder if none selected yet). If a breed is selected, perhaps a thumbnail or icon is shown with it.
* **Validation Messages:** If the user attempts to proceed without two selections or with the same breed in both fields, an inline error message is shown (e.g., “Please select two different breeds”). The “Compare” button remains disabled until valid input is provided.
* **Breed List for Selection:** When the user interacts with a selection field, an output is a list of breed options (likely the same list data as the Breed Encyclopedia). This could appear as a dropdown or separate dialog. The list can be filtered via search as well to quickly find a breed.
* **Pre-selected Breed:** If the screen was launched with one breed pre-selected (from a detail page), that breed’s name is already displayed in one of the fields.
* **Compare Button:** A prominent button (or similar control) labeled “Compare” that becomes enabled once two valid selections are made.

**Navigation:**

* **Entry:** The user reaches this screen by choosing a “Compare breeds” function. This might be via a button on a Breed Detail (which opens the comparison with one breed filled), or via a menu item on the main UI (which opens an empty comparison screen for the user to pick both breeds). It could also be accessible from a bottom navigation if the app design includes Comparison as a main feature entry point. In any case, the screen appears as a new page where user can make selections.
* **Exit:**

  * On tapping “Compare” with two breeds selected, the app navigates to the **Comparison Result Screen** which displays the side-by-side comparison. The selected breed identifiers are passed to that screen.
  * If the user presses back (or cancel), they return to the previous context: either back to a breed detail (if they came from there) or back to whatever screen launched the comparison (if it was from a menu, maybe back to a main screen like Breed List).
  * The user can also navigate away using global navigation (e.g., switching to Profile tab) which would abandon the comparison process.

**Functionality:**

* **Populate Breed Options:** The screen utilizes the breed list data (same dataset from Breed Encyclopedia). If that data is already in memory/cache, it uses it to populate the selection options. Otherwise, it fetches the breed list from the database. The selection inputs likely allow typing to search, making use of the breed names list.
* **Pre-selection Handling:** If a breed ID is passed in (from a prior screen’s context), the screen will automatically set Breed A (or B) to that breed. It will load that breed’s name and possibly image into the selection field. The user then only needs to select the other field. The pre-selected field can still be changed by the user if they want to compare two completely different breeds.
* **Input Validation:** The screen logic ensures that:

  * Both Breed A and Breed B must be selected (not null).
  * Breed A and Breed B cannot be the same. If a user tries to select the same for both, the second selection either automatically prevents choosing the one already chosen, or immediately prompts “Choose a different breed.” The Compare button will remain disabled until this is resolved.
* **Compare Initiation:** When “Compare” is tapped, the app double-checks the inputs and then triggers navigation to the results. It may also perform any necessary pre-loading of data for the result screen (though likely the result screen will fetch needed details itself). For instance, it could fetch both breed detail records now (especially if it doesn’t have them from cache) and pass them to the result screen to avoid delay there. Alternatively, the result screen will fetch them on its own. Either approach is fine; from the user’s perspective, after tapping Compare they’ll see the result screen after a brief transition/loading.
* **Performance Consideration:** Since the number of breeds is not huge (\~60), loading all options is quick. The search-as-you-type in the picker should be fast and can be client-side.
* **Error Handling:** If for some reason the breed list cannot be loaded (and wasn’t already cached), the screen will show an error in the selection fields (“Breed list unavailable”). The user might see empty dropdowns. In such case, the compare function cannot proceed. A retry mechanism could be offered to load the data. If the user is offline and hasn’t cached the breed list, the screen should inform them that breed data is unavailable offline for selection. If one breed was pre-set from a cached detail but others aren’t loaded, at least that one shows, but the second breed selection would fail until online.
* **Offline Notes:** If the user has the breed list cached from prior usage, they can initiate a comparison offline. The selection fields will show the cached list of breeds for both A and B. The user can pick two and hit Compare. The Comparison Result screen will then attempt to show details for both. If those breed details were also cached (likely yes, if the list cache included all needed fields or at least if each breed’s detail had been loaded at least once), then the comparison can be generated offline. If a breed’s details aren’t in cache, the result screen may not have all info offline – this scenario should be communicated (e.g., “Some data not available offline”). Ideally, the breed list cache includes enough info for comparison (or the app could choose to store key comparison fields offline). In short, offline comparisons are possible for already-known breeds, but if any data is missing, the user will be informed that an internet connection is needed to get complete info.
* **Navigation Continuity:** After returning from the result screen (back to this selection or previous), the app may or may not preserve the last selected options. It could clear them to default if the user goes back to do a new comparison. If the user navigates away mid-selection, no harm – it’s just form inputs not submitted.

## Comparison Result Screen

**Purpose:** Display a side-by-side comparison of two selected cat breeds, highlighting their similarities and differences across various attributes. This screen helps the user easily contrast the traits of Breed A and Breed B.

**Inputs:**

* There are minimal direct inputs on this screen since it primarily shows results. However:

  * **Scroll:** The user can scroll vertically to view all comparison details if they don’t fit on one screen (especially on smaller devices).
  * **Breed Detail Drill-down:** The user can tap on either breed’s name or image to navigate to that breed’s detail screen for more comprehensive information, if desired. (For example, if after comparing, they want to read the full description of one breed, they can tap that breed’s section.)
  * **New Comparison:** The user might have a button or option “New Comparison” or “Change Breeds,” which if tapped, could take them back to the comparison selection screen to choose different breeds. Alternatively, they can hit back to go back and modify the selection.
  * **Back Navigation:** Tapping back returns to the comparison selection screen (or wherever they came from).

**Outputs:**

* **Breed Headings:** At the top, the two selected breeds are named. For example, “**Breed A** vs **Breed B**”. Each name might be accompanied by a thumbnail image of that breed for quick visual identification.
* **Comparison Table or Side-by-side List:** The core of the screen is a structured layout listing each attribute with the values for Breed A and Breed B side by side. Key outputs include:

  * **Images:** Under each breed name, a larger image of that breed might be shown (if screen space allows) so the user can visually compare appearances.
  * **Description (short):** Possibly a very brief summary or tagline for each breed (one or two sentences) for context. The full description is likely too long to put side by side, so not usually included fully. Instead, a link “View more” might be present to go to Breed Detail.
  * **Origin:** Both breeds’ origin are listed (e.g., “Thailand” vs “United Kingdom”).
  * **Life Span:** e.g., “12–15 years” vs “14–16 years”.
  * **Size/Weight:** if available (e.g., “Medium (8–12 lbs)” vs “Large (10–15 lbs)”).
  * **Temperament:** possibly a few keywords for each (though temperament is often multiple words; it could be listed or bullet for each breed in their column).
  * **Trait Ratings:** This is where side-by-side shines. The screen will list traits like Adaptability, Affection Level, Child Friendly, Grooming Needs, Intelligence, Health Issues, Social Needs, Stranger Friendly, etc. For each trait, it shows Breed A’s value and Breed B’s value adjacent. For example:

    * Adaptability: **Breed A:** 5/5 vs **Breed B:** 3/5
    * Grooming Needs: **Breed A:** Low vs **Breed B:** High (or could be 2/5 vs 5/5).
      These make it easy to compare which breed scores higher on a given trait. A visual indicator like a bar or stars may be shown for each within each column.
  * **Other attributes:** If there are special attributes (like coat type, pattern, etc.), those can be compared textually (“Coat: Long hair vs Short hair”).
* **Highlight Differences (optional):** The UI might highlight the differences in some manner (like bolding or coloring the higher rating in each row, or arrows indicating which breed has more of a certain quality). This helps the user spot key differences quickly. (This is a UI detail, but worth noting as a potential feature to enhance comparison clarity.)
* **No Data Placeholder:** If for some reason an attribute is not available for a breed (e.g., missing data), the screen should show “–” or “N/A” for that entry for that breed, and not crash the comparison layout.

**Navigation:**

* **Entry:** This screen appears after the user selects two breeds and initiates the comparison. It expects to receive two breed identifiers (or full data objects) for Breed A and Breed B from the previous screen. It could also theoretically be deep-linked or saved (though unlikely, as it’s dynamically generated content).
* **Exit:**

  * Back navigation takes the user back to the Breed Comparison selection screen, pre-filled with the last selection (so they could adjust one breed and compare again, or pick new ones). If the user came from a Breed Detail via a shortcut, back might take them all the way back to that detail (though typically it would go to selection first, which then back again to detail – this depends on navigation stack design).
  * If the user taps on a breed’s name or image on this screen, the app navigates to the **Breed Detail Screen** for that breed. After viewing details, if they press back, they should logically come back to the comparison result (to continue comparing or go back to selection). This implies that from the comparison result, opening a breed detail creates a deeper level in the stack.
  * The user can also initiate a new comparison via a button on this screen (if provided), which essentially might clear or reset the comparison selection screen or directly open a fresh selection. This could be treated the same as a back navigation to selection (but perhaps easier for the user by one tap).
  * Global navigation (switching tabs, etc.) can take them elsewhere, leaving this screen. On return, the state might be gone unless we preserve it, but that’s a design decision.

**Functionality:**

* **Data Gathering:** Upon arriving, the screen ensures it has the full details for both breeds to present. If the previous screen passed complete breed info (including all attributes needed for comparison), the screen can use that directly. If only IDs were passed, the screen will perform two database lookups in parallel: fetch Breed A details and Breed B details from Firestore. A loading indicator or skeleton view may be shown while fetching. Once both are retrieved (or retrieved from cache), it populates the comparison fields. If this data was cached from earlier (very possible, since the breed list or details might already be in memory from earlier screens), the app will use cached values immediately.
* **Display Side-by-side:** The app dynamically generates a comparison table. For each attribute category (Origin, Life Span, etc.), it populates the values under each breed. The layout might be two columns under breed headings. On smaller screens, it might instead be a vertical list where each breed’s info is in a sub-column – but ideally side-by-side if in landscape or tablet. For phones in portrait, side-by-side is still doable by using columns that scroll vertically together. The design should ensure readability.
* **Interactivity:** The breed names/images at the top are interactive, linking to breed details (as mentioned). This uses the existing navigation to Breed Detail with the given breed data.
* **Comparing Values:** If numeric values exist (1–5), the app might convert them to a user-friendly form (like star icons or adjectives). For instance, a 5/5 might show as “★★★★★” or “High” whereas 1/5 is “★☆☆☆☆” or “Low”. This consistent representation helps in quick visual comparison. The functional requirement is to translate raw data into understandable info for the user.
* **Differences Highlight (if implemented):** The app can check each comparable attribute and if one breed has a higher value (for positive traits like affection, intelligence) or a lower value (for traits like grooming needs where lower might be considered “easier care”), it can highlight accordingly. This might involve simple logic but is not strictly required by core functionality – it’s a UI enhancement.
* **Error Handling:** If either breed’s data fails to load (e.g., lost connection and not in cache), the screen should display an error message for that breed’s column. For example, Breed A’s column could say “Data not available” if it cannot fetch. The comparison for that row would then be incomplete. The user could be prompted to retry (maybe a refresh button) once connection is back. If a specific attribute is missing for one breed, it’s handled by showing “N/A” on that side, as mentioned.
* **Data Validation:** This feature assumes all necessary data for both breeds is present. The system should ensure consistency of units and scales when comparing. E.g., if weight is stored in one breed as kilograms and another as pounds, the app should standardize before display. If life span is stored as a range or as an average, it should present them comparably (likely as given). Ideally, the admin data entry enforces a uniform format for attributes, so the comparison is apples-to-apples. This SRS would note that consistency (like both life spans are in years range, both weights in same unit, rating scales uniform 1–5) is required for meaningful comparison.
* **Offline Notes:** If both breeds’ info is cached, the comparison will work offline. The app will use the cached data to populate the table. If one or both are not cached, those fields will remain blank or show an error as described. The user would need to go online and refresh. The selection screen likely prevented starting a comparison for breeds that had no data, but since the selection only ensures breed names, it might not know if details are cached. Therefore, the comparison screen itself must handle offline gracefully. Possibly, the app could cache all breed details once any breed list is loaded, to fully enable offline comparisons. This could be mentioned as a strategy: *All breed data (used in comparisons) should be stored locally after initial fetch so that comparison and detail features work offline.* Firestore can cache documents as they are fetched; if we query all breed documents at startup for the list, then we effectively have all details offline. In any case, offline behavior is that the screen tries to retrieve from cache and will show whatever it has.
* **Post-Comparison Actions:** The screen doesn’t directly alter data; it’s read-only. But from here the user can navigate to breed details or start a new comparison, which have their own functionality as described in those sections. There’s no direct persistence from this screen except maybe logging an analytics event (not required) that two breeds were compared.

## Cat Recognition Screen (Photo-Based Breed Prediction)

**Purpose:** Enable the user to identify the breed of a cat by taking a photo or uploading an image. This screen is the interface to the Cat Recognition AI feature – the user provides an image of a cat, and the app will predict the breed. It’s essentially a tool for breed discovery from images.

**Inputs:**

* **Take Photo (Camera):** The user can tap a “Camera” button/icon to launch the device camera via Flutter’s camera interface. They then take a photo of a cat. Upon capture, the photo is returned to the app for analysis.
* **Choose from Gallery:** Alternatively, the user can tap a “Gallery” or “Upload” button to select an existing photo of a cat from their device’s gallery. They navigate the file picker and choose an image.
* **Confirm/Analyze:** Depending on UI flow, once a photo is chosen, the user might have to confirm by tapping an “Analyze” or “Recognize” button. In some designs, simply selecting the photo could immediately begin analysis. This SRS will assume an explicit action to start analysis after selecting, to allow the user to make sure they selected the correct image.
* **Cancel:** The user can decide to cancel the operation (e.g., cancel out of the camera or gallery picker, or press back to not proceed with analysis).

**Outputs:**

* **Image Preview:** After the user selects or captures an image, a preview of that image is displayed on this screen. This allows the user to verify it’s clear and contains the cat they want to analyze. They might have an option to re-take or select a different picture if needed.
* **Instructional Text:** The screen initially (before photo selection) might display instructions like “Take a photo of a cat or upload one to identify its breed.” This guides the user on what to do. After an image is selected, instructions might change to “Tap Analyze to identify the breed.”
* **Buttons/Icons:**

  * A camera icon/button for taking a photo.
  * A gallery icon/button for uploading.
  * Once an image is present, an Analyze/Recognize button. This might replace the initial buttons or appear additionally. If analysis auto-starts, a cancel button might appear instead.
* **Loading Indicator:** When the user initiates analysis on the photo, a loading progress indicator (spinner or progress bar) is shown with a message like “Identifying breed…”. This indicates that the app is processing the image (either locally or uploading to server for AI).
* **Error Messages:** If something goes wrong (e.g., no cat detected, or the image is too large), the screen might display an immediate error dialog or message before leaving this screen. For example, if the user selected a non-image file or the image is corrupted, an error “Invalid image, please try another.” would be shown.
* (Note: The actual recognition results are shown on the next screen, not here, to keep this screen focused on input.)

**Navigation:**

* **Entry:** The user accesses this screen by selecting the “Cat Recognition” feature. This could be via a dedicated tab or menu item labeled something like “Identify Breed” or an icon of a camera. It might also be from a home dashboard. In any case, it’s a primary feature screen.
* **Exit:**

  * When the user confirms an image and starts analysis, upon completion the app navigates to the **Recognition Result Screen** to display the outcome. The transition might happen automatically once the result is ready (the app could push the result screen when AI returns predictions).
  * If the user cancels or presses back before analyzing, they return to whichever screen they came from (maybe a main menu or home). If recognition is a tab, pressing back might exit the app (if it’s the initial screen) or just stay on an empty state of this screen if it’s tabbed.
  * After analysis and viewing results, when the user comes back (via back navigation from results), they typically return to this recognition input screen to possibly try another image. There might also be a “Try another” option on the result that pops back here.
* **Navigation to other features:** The user can switch to other tabs (like Breed list or Profile) without completing an analysis; in doing so, any selected image or progress is typically discarded.

**Functionality:**

* **Camera Integration:** The app uses device camera via Flutter plugins (e.g., `image_picker` or `camera` plugin). When the user taps the camera button, the app requests camera permission if not already granted. The camera UI opens, the user takes a photo, and the image is returned (probably as a file path or binary data). The app then displays it on the screen. If the user cancels the camera or denies permission, handle accordingly (permission denial yields an error message guiding to enable camera, cancellation just returns to the screen with no image).
* **Gallery Integration:** Similarly, tapping the gallery button uses an image picker to let the user choose a photo. It requires storage permission on Android (or photo library permission on iOS). If denied, prompt the user. On selecting an image, the app gets the image file. It likely downsizes or compresses it if needed (to reduce upload or processing time). The chosen image is then displayed as a preview.
* **Image Validation:** The app should validate the image before sending for analysis: ensure it’s in a supported format (JPEG/PNG typically), not excessively large resolution (the app might downscale large images to, say, 1080px max dimension for faster processing), and possibly ensure it's not an empty file. Optionally, it might check if the image likely contains a cat before sending to the AI (some services might do a quick check or the AI itself will handle that). For simplicity, we assume the AI model will handle detection of whether a cat is present.
* **Initiate Analysis:** When the user taps Analyze, the app either:

  * **On-Device Model scenario:** Passes the image to a TensorFlow Lite model embedded in the app. Processing happens locally, returning a prediction of breed(s). This would not require internet and would be fast (a couple of seconds).
  * **Cloud API scenario:** Uploads the image to a backend service or calls an API (e.g., a Cloud Function or third-party API like TheCatAPI or Zyla API) which returns the breed prediction. This requires internet. The image might be uploaded to Firebase Storage or sent directly as bytes to the API.
    In either case, the user sees a loading indicator while this happens. For this SRS, we won’t commit to the implementation detail, but we will note that an AI service is invoked to get predictions.
* **Progress and Timeout:** If the analysis is taking too long (say >10 seconds), the app might time out or offer the user the chance to cancel/retry. Ideally, predictions come in a few seconds.
* **Logging (for admin logs):** As soon as a recognition attempt is made, the app should log the attempt. This could happen in two places: either right before sending to AI (log an attempt started), or after receiving results (log the outcome). Logging data to Firebase could include: a timestamp, the user’s ID (or “anonymous” if not logged in), maybe a reference to the image (if stored) or some hash, and the predicted breed(s) with confidence. If using a cloud function for AI, that function itself might log to the database. For SRS, we specify that the app (or backend) will record each recognition attempt in a “recognition\_logs” collection for admin review.
* **State Reset:** After initiating the analysis, once the result is obtained and the user moves to the result screen, this input screen might reset. So that if the user comes back to it, it’s ready for a new photo (the previous preview might be cleared). Alternatively, if they hit back *during* the loading, it might cancel the analysis. Cancelling should abort the AI call if possible, or ignore the result when it arrives.
* **Data Validation:** Ensure the user actually provided an image before starting analysis (the Analyze button should be disabled until an image is present). If by any chance a non-image slips through or the image file is inaccessible, handle that error. If the user tries to use a very small or poor-quality image, the model might not work well – possibly advise user to use a clear image. (This could be in instructions: “Use a clear photo of the cat’s face and body.”)
* **Error Handling:**

  * **Permission Errors:** If camera or gallery access is not granted, show a message explaining the need and possibly navigate to app settings.
  * **No Image Selected:** If user taps “Analyze” without image (shouldn’t happen if button is disabled), show “Please select an image first.”
  * **AI Errors:** If the AI service returns an error (e.g., no cat detected, or network failure), the app should catch that. In case of no cat or unrecognizable breed, the result screen can handle it by showing “Breed not identified” or similar. If it’s a network error, the app might show a popup on this screen like “Could not connect to the recognition service. Please check your connection and try again.”
  * **Offline Handling:** If the recognition relies on cloud and the device is offline, the app should not let the user even try. It can detect no internet and show a message on this screen like “Internet connection required for breed recognition.” Possibly the Analyze button stays disabled in offline mode, or a dialog appears if they try. If using an on-device model, this is not an issue (it would work offline). We’ll assume cloud-based for now: hence, require connectivity.
  * **Large Image:** If the image is too large to handle (could cause out-of-memory), the app should downscale or inform the user. Typically handled internally by downscaling.
* **Offline Notes:** As noted, if using a cloud API, this feature will not function offline. The screen should detect offline status and either disable the camera/gallery actions or at least warn that analysis cannot be done until online. The user might still take a photo offline, but upon hitting Analyze, the app would realize no connection and could queue the request – but queuing an image analysis isn’t very feasible (since real-time result is needed). Better to block or message: “You are offline. Connect to the internet to identify a breed.” If using an on-device model approach, offline is supported; in that case, none of this applies and the feature works anytime. The SRS can note both possibilities: currently assume online requirement, but mention the alternative if model is bundled.
* **Security/Privacy:** If images are uploaded to a server (like Firebase Storage), ensure they are stored in a secure way. Possibly they go to a restricted bucket (only admin can review). This might be described in admin logs part. The user should be informed if images are kept (maybe in privacy policy). For our purposes, recognition logs may include images for admin, which implies storing them. We specify under Admin that images might be accessible.
* **After obtaining result:** The function of this screen is done and it navigates to the result. Memory of the image can be cleared if not needed further (unless we keep it for admin logs or to display on result screen as reference – showing the photo on result screen might be nice).

## Recognition Result Screen

**Purpose:** Show the outcome of the Cat Recognition AI analysis. This screen presents the predicted breed(s) based on the submitted photo, giving the user insight into what breed the cat in the image might be. It also allows the user to take follow-up actions, such as learning more about the predicted breed or trying another photo.

**Inputs:**

* **View Breed Details:** If the AI predicts one or more breeds, the user can tap on a predicted breed name or card to see the Breed Detail Screen for that breed. This allows them to get extensive information on that breed, as a next step after identification.
* **Try Another (Again) Action:** The user can tap a “Try Another Photo” button or link to go back to the Recognition screen to identify another cat or retry if needed. This basically navigates back and resets the recognition input flow.
* **Feedback (Optional):** Some apps allow the user to give feedback like “Was this correct?” or to manually select which prediction was right if multiple were given. The prompt does not mention this feature, so we will not include detailed feedback mechanism. But as an idea, user input could be used to improve the model if implemented (out of scope here).

**Outputs:**

* **Analyzed Image Preview:** The screen shows the photo that was analyzed (probably a thumbnail or a fit-to-screen version) so the user is reminded of what was submitted. This helps provide context to the results, especially if the user is identifying multiple cats in sequence or returns later.
* **Prediction Results:** The core content is the list of predicted breeds with confidence levels. There are a few scenarios:

  * **Single Breed Match:** If the AI is fairly certain, it might output a single breed as the result. In this case, the screen might say “This cat appears to be a **Siamese**.” Possibly with a confidence like “Confidence: 95%”.
  * **Multiple Possible Breeds:** Often, image recognition provides a ranked list of possibilities. The screen could list the top 3 (or top N) predictions. For example:

    1. **Siamese** – 95% confidence
    2. **Birman** – 60% confidence
    3. **Persian** – 40% confidence
       Each of these might be displayed as a card or list item. The top result is usually highlighted. The confidence could be shown as a percentage or a bar. This aligns with how the API results are structured (a list of possible breeds with confidence scores). If the model can detect mixes, it might even say “Breed A/B mix” but that’s advanced; likely it just lists possibilities.
  * **No Confident Match:** If the model isn’t confident beyond a threshold, it might effectively say “Unknown” or “Unable to identify breed.” The app should handle this by showing a message like “Could not identify a specific breed” or maybe show the top guess but with low confidence and a caveat.
* **Result Text:** The screen could have a friendly explanatory text. For example, if one breed is found: “Our AI thinks this cat is a Siamese.” If multiple: “Our AI is not certain, but here are the most likely breeds:” followed by the list.
* **Breed Info Snippet:** Next to each predicted breed (especially the top one), it might be nice to show a tiny snippet like the breed’s thumbnail image or a one-liner description. At least showing an image icon for the breed can reassure the user visually (like if their cat is gray and fluffy and the image for Persian shows a gray fluffy cat, that reinforces the match). This requires the app to link the AI result (which is a breed name or ID) to the breed database to fetch that breed’s image or data. That is feasible since our app has breed info. So the output can include breed names as clickable items, possibly with thumbnails.
* **Error Display:** If the analysis completely failed (no result due to a technical error), the screen should display a message like “There was an error analyzing the image. Please try again.” and possibly a retry button right there. If the user came here despite an error, at least that message is shown instead of predictions.
* **Log Confirmation (internal):** Not visible to the user, but by the time this screen is shown, a log entry should have been created (if not already) in the admin logs. The output to admin is covered in Admin section, but from the user perspective there is no visible effect of logging.

**Navigation:**

* **Entry:** This screen is reached immediately after the image analysis is done. The app likely pushes this screen onto the stack once results are ready, so it “pops up” after the recognition loading. (Alternatively, the recognition screen could itself show results inline, but the requirement asked for a distinct result screen.) So, the transition is automatic in most cases.
* **Exit:**

  * If the user taps on a predicted breed name or card, the app navigates to that **Breed Detail Screen**. From the detail screen, if they press back, they should logically come back to this result screen (so they can maybe look at another result or tap “Try another”). We must ensure navigation stack handles that properly.
  * If the user taps “Try another photo” (or uses back), the app goes back to the **Cat Recognition Screen** to allow a new analysis. This likely clears the previous image and result. If a dedicated button is given, it might pop two screens off the stack (the result and possibly reset the recognition screen). More straightforward: from result, back goes to recognition input with last image cleared automatically. Alternatively, a “New Photo” button could directly launch the image picker again from here. But simplest is go back to the previous screen to start over.
  * The user can also use global navigation to go elsewhere (e.g., switch to Encyclopedia tab), leaving this result. If they come back to recognition later, it might start fresh. The result isn’t typically stored long-term (unless we show history, which we do not).
* **Persistence:** If the user identified one cat and stays on this screen, and then rotates the device or background/foreground, the app should preserve the result (so on rotation they don’t lose it). This means the data should be kept in state or re-fetchable. It’s a given requirement to handle typical app lifecycle gracefully (like any screen). Not a separate nav item, but a detail to implement.

**Functionality:**

* **Display Results:** The app takes the results from the AI (likely a list of breed names and confidence scores). It matches these breed names with those in the app’s breed database to get their display name (which should be the same string ideally) and possibly an image or description. If the AI returns standardized breed identifiers matching our DB, we can directly query for those breed entries to get images. If it returns just names, we might map name to our data (which is fine if they are consistent). The top result (first in list) will be displayed prominently. Others may be shown slightly less prominently (maybe collapsed under a “More likely breeds” section or just listed in descending order). For example, the UI might show the top result as a big card and the next two as smaller list items.
* **Confidence Interpretation:** The raw confidence (0.0–1.0 or percentage) is shown for transparency. We might format it as a percentage (e.g., 0.95 -> “95% confident”). If only one result, we might still show the confidence or phrase it qualitatively (“very confident” if >90%, etc. – but that might confuse, better stick to numbers or bars). The Zyla API description suggests returning a list of possible breeds with confidence scores, which we are following.
* **Multiple Cats / Non-cat scenarios:** If the user’s photo had no cat or multiple cats, the AI might either fail or still give a result for the dominant object. The app can note if no cat found. If multiple cats, typically one result will show (perhaps the one for the largest cat in image). The app does not explicitly handle multiple separate results on the same image – that’s beyond scope (assuming user will provide one cat at a time). We can note: if no cat is detected by the model, the result might be “No cat detected. Try a clearer photo.”
* **Logging:** The app (or cloud function) writes an entry to the logs. We mention here that after showing results, ensure that a log entry exists. It should contain at least the top result and confidence, timestamp, user. If images are stored for logs, maybe by now the image was already uploaded to storage. (Perhaps the upload could have been done in parallel with analysis or after – detail not needed in SRS, but mention that admin will have access to the image via logs if implemented).
* **Error Handling:**

  * If the AI returns a special “error” response (like an exception or no result), the app should catch that and instead of showing predictions, show a user-friendly error on this screen. Possibly it could stay on previous screen with an error dialog, but assuming it navigated here, it should say e.g. “Sorry, we couldn’t identify the breed from this photo.” and give the user the option to try again (which goes back). If the error is due to no cat found, similar message. If due to network, ideally the app wouldn’t have navigated here, but if it did, mention network error and maybe provide a retry that goes back to input.
  * If the result is extremely low confidence across the board (like all predictions <20%), it’s essentially an “uncertain” case. The UI can handle it by listing them but perhaps with a note “The results are not very confident. The cat might be of an uncommon breed or a mix.” (This gives the user context that the identification might not be reliable in that case.) This note is not strictly necessary but improves user understanding.
* **Offline Notes:** This screen by itself doesn’t function offline since it requires coming from a successful analysis which presumably required online (unless on-device model). If the user somehow got here offline (which shouldn’t happen normally), it would have no data to show. Thus, offline use of this screen is not applicable except viewing a result that was already fetched (like if connection drops after the result is obtained, the screen can still show it since the data is local at that point). If using on-device model, then this screen could appear offline with results no problem, since the analysis was done offline. So in that scenario, offline is fully supported for recognition. We just clarify: recognition results require either prior analysis or connection depending on design.
* **UI Continuation:** If the user taps on a breed result: we navigate to Breed Detail as specified. The app should pass along the breed ID for the detail page to load (which likely we have since we matched the breed name to our DB). The detail screen then works as usual (and the user can favorite the breed if they want, etc.).
* **No Social Sharing:** Unlike some apps, we are not implementing a share button to share the result image and breed on social media. Since it’s a solo experience app, we refrain from social features. If asked, the user could always screenshot themselves, but no built-in share.
* **Try Another:** If the user wants to identify another cat, they can hit “Try Another Photo” which essentially resets the flow. The app might pop this screen, clear the previously selected image from the recognition screen, and ready the camera/selection again. In implementation, maybe easier: the button could directly open the image picker or camera again. But navigation-wise, going back to the input screen is fine. We ensure the input screen is reset (the previous image preview cleared and any loading state off). Possibly, it’s easiest to completely restart that screen’s state.

## Cat Fact Hub Screen

**Purpose:** Provide the user with interesting cat-related facts, particularly a “Daily Cat Fact” for educational or entertainment purposes. This feature is a hub where a new fact is available each day (or on demand) for the user to read, without any gamification or quizzes – just plain facts.

**Inputs:**

* **Browse Facts:** The user can swipe or navigate to see different facts. If implementing daily facts strictly, the main interaction might simply be reading today’s fact. However, to make use of stored facts, we might allow the user to browse previous or random facts. Possible inputs:

  * Swipe left/right to move to the next or previous fact (if we allow that).
  * A “Next Fact” button to fetch another random fact from the collection (if not restricting to one per day).
  * A refresh gesture or button if they want to get a new fact (again, depends on design choice of one-per-day vs on-demand random).
* **Share (Optional):** Not required by prompt and since it’s solo, we won’t include a share button, but conceptually a user might want to share a cool fact externally. We’ll skip this in the SRS as it’s not core.
* **No user text input** is needed; it’s just reading content.

**Outputs:**

* **Today’s Fact:** On launch, the screen prominently displays the cat fact of the day. This is typically a sentence or two containing an interesting trivia about cats. For example: “Cats have five toes on their front paws, but only four toes on their back paws.”

  * The fact can be presented in a stylized way (large font, maybe a cat-themed background or an illustration if available – though not required).
* **Fact Identifier:** Possibly the date or a number like “Fact #42” or “Fact of the Day – May 25, 2025” so the user knows this is today’s fact. If daily, showing the date can emphasize its freshness.
* **Navigation Controls:** If we allow multiple facts:

  * A **Next** or **Random** button to get another fact.
  * If swiping is enabled, small indicators might show which fact number or allow going back to previous facts. Or a list icon if we let them open a list of all facts (this might not be needed if the idea is one-per-day; listing all might reduce the daily novelty).
* **Loading Indicator:** If the facts are being fetched from the network, and not immediately available, a spinner or “Loading fact...” message might appear momentarily.
* **Error Message:** If the fact fails to load (network issue and no cache), the output could be an error note like “Unable to load cat fact. Please check your connection.” In an offline scenario with cache, maybe show the last retrieved fact with a note.

**Navigation:**

* **Entry:** The user can access the Fact Hub via a main navigation (perhaps a tab or menu labeled “Cat Facts”). It does not require login – any user can read facts. Upon entering, it shows the current fact. This screen is likely a top-level section just like Encyclopedia or Recognition.
* **Exit:**

  * The user can navigate to other sections (Breed list, Profile, etc.) via global nav, leaving the facts section. There’s typically no deeper screen within facts that requires back navigation, unless we implement a list of facts or something. If facts were browsable sequentially, the user might scroll through them in the same screen or use in-screen nav rather than separate screens per fact (facts are short, so a separate screen for each fact is probably unnecessary – more likely we just update content in place).
  * If we had a list of all facts (less likely), tapping one might open a “Fact Detail” screen, but that’s overkill. The prompt suggests a hub, so probably one screen cycling through content.
  * Therefore, leaving is usually just switching tabs or closing the app. No special back behavior except leaving the section.

**Functionality:**

* **Daily Fact Logic:** The app should determine which fact to show as “Fact of the Day.” There are a couple of approaches:

  * **Predefined daily sequence:** The facts in the database might have an assigned date or sequence number. For example, the admin could have loaded facts and marked some as the fact for specific dates. But that’s not mentioned, likely too much manual work.
  * **Random daily selection:** Each day when the user opens the app, it picks a random fact from the collection (one that maybe hasn’t been seen recently). It can either be truly random or cycle through the list. If truly random, could repeat eventually, but large pool would mitigate that.
  * **Deterministic daily:** Use the date as a seed/index. For instance, take the day of year mod number of facts to pick one. This way, all users see the same fact on the same day (which is nice if it’s called a daily fact). This can be done without storing anything extra: e.g., sort facts by ID and pick the Nth for today’s date. Or have a “fact\_of\_the\_day” field updated daily by admin, but that would require manual or cloud function automation.
  * For SRS simplicity, we can say: The app will present one featured fact each day (all users see the same daily fact). The selection can be automated either via a schedule or pseudo-random algorithm. The exact mechanism can be decided during implementation (maybe using current date to index into the facts list).
* **Fetching Facts:** The facts themselves are stored in Firebase (perhaps in a “facts” collection). Each fact entry might contain the fact text and maybe an ID or date. On entering the Fact Hub, the app queries the database for the relevant fact(s). If implementing daily deterministic by date, it might fetch all facts or the one matching an index. Simpler: fetch all facts on first launch (the data is small textual data), cache them, then pick from the list. Or fetch a random one via a Firestore query (like Firebase doesn’t directly support random, but one can fetch all IDs and pick one client side or use Cloud Function).

  * Possibly, to avoid heavy lifting on client, the app might just fetch one “current fact” document. We could have a document that is updated (maybe manually by admin or via scheduled function) each day to the new fact. But since admin panel exists, maybe not to burden the admin with daily updates, a more automatic approach is better. Let's not assume admin will set daily facts each day, rather just maintain a pool.
  * **We'll propose**: The app will fetch one fact for display. If the app stores last shown date in local storage, it can ensure it doesn’t change facts within the same day for that user. But if we want consistency across users, a global approach (like date-based selection or an admin-specified daily fact) is needed.
  * For now, say: The app by default shows one fact (which changes daily). Implementation might be by date index – e.g., each day the app chooses the fact at index (current\_date mod number\_of\_facts) from the facts collection.
* **Displaying Fact:** The fact text is displayed in a nice, readable format. If facts are very short, could enlarge text. If some facts are longer (a few sentences), ensure the layout accommodates wrapping text. Possibly add an illustration or cat icon just for aesthetics (not a requirement, but UI detail).
* **Browsing More Facts:** Because prompt says “Cat Fact Hub (daily facts, not gamified)”, it implies at least daily a new fact appears. It doesn’t forbid letting the user see more facts in one sitting. We should allow some browsing, otherwise it’s a one-fact-per-day limit which some users might find too little content. Many “daily fact” apps still let you scroll through past facts or tap to see another random fact.

  * So, we can include a feature: The user can request another fact (perhaps not counting as “daily” but just browsing the archive). For example, after reading today’s fact, a button “More Facts” can fetch a random different fact. This does not affect the “fact of the day” which remains the one marked for that date on initial load. It just gives additional content if user wants.
  * Alternatively, a chronological list of previous daily facts could be accessible (like a small list below or a separate screen). But listing them all might reduce the novelty; it’s optional.
  * For simplicity: implement a “Random Fact” on demand. Each time pressed, pick a random fact from the database and show it (maybe labeling it “Random Fact” rather than "Daily"). The user can do this repeatedly. However, ensure not to serve the same fact repeatedly in one session – we could exclude the last shown from the next random pick.
  * This satisfies those who want to binge facts, while still highlighting one daily when they first open it.
* **Data Validation:** Ensure each fact retrieved has content. The admin likely just enters text for facts. If a fact entry is blank or extremely long, handle that. Possibly set a reasonable maximum length for facts (maybe a few sentences, up to 200 characters or so, unless admin enters longer paragraphs). If a fact is too long to fit nicely on screen, the UI should allow scrolling or smaller font for that fact. But ideally, facts are concise.
* **Error Handling:** If the facts collection cannot be accessed (no internet), the app should try to use a cached fact. Firestore offline would have cached any facts that were loaded previously. If the user has opened the fact section before while online, at least that fact may be cached. We might cache multiple or all facts for offline use if we fetched them.

  * If offline and no cached fact, show an error: “No fact available offline.” Possibly show a generic static fact baked in or instruct to connect. It's not critical data, so just an error message is fine.
  * If user tries to fetch a random fact offline, similarly either no action or an error because it can’t retrieve a new one unless all were cached (if we fetched all at start, then random is possible offline too from cache).
* **Offline & Caching:** We should leverage offline persistence so that once a fact is fetched it stays available. Possibly pre-fetching the entire set of facts on first use (since text facts are small and maybe not too many) is wise, then offline all facts are available. But if the facts DB grows large, maybe not. Probably it's fine to have dozens or a hundred facts and still fetch all.

  * We'll mention: The app caches fact data for offline reading of previously seen or loaded facts.
* **Admin Updates:** If admin adds new facts to the pool, those should eventually reach the app (like next time it fetches or if the user triggers refresh). If using the date-index approach, adding or removing facts changes the indexing possibly. But that’s okay, just perhaps do mod on updated count. If admin specifically wants to push a certain fact as daily, they might currently have no direct control unless they remove others or mark it. Since not gamified, likely they don’t mind random.

  * We can mention: Admin can add facts at any time; the app will include them in its pool for future days or random picks. Removing facts will also reflect (though if one was scheduled for today by algorithm, might skip to next). These are edge cases not crucial for SRS.
* **No Gamification:** Emphasize that there are no points, no streak tracking, no quizzes. Some apps gamify by giving points for reading or guessing facts. Here, none of that. It's purely informational, so the UI is straightforward: just display facts.
* **Notification (out-of-scope):** Sometimes daily facts come with daily push notifications (“Your cat fact of the day: ...”). The prompt doesn’t mention notifications, so we won’t include that. But it’s a potential feature beyond SRS if they wanted to engage users daily. We'll assume not included since not asked.
* **Logging:** Not necessary to log user views of facts or track which fact shown (unless for analytics), but not required here. It's mostly static content usage.

## Admin Dashboard (Overview for Admin)

**Purpose:** Serve as the main entry point and overview for an admin user to manage the app’s content and view system logs. It presents navigation to the specific admin functionalities (Breed management, Facts management, Recognition logs) and potentially highlights key information at a glance (like counts of breeds/facts).

**Inputs:**

* **Navigation Buttons:** The admin taps on one of the management sections:

  * “Manage Breeds” to go to the Admin Breed Management Screen.
  * “Manage Facts” to go to the Admin Fact Management Screen.
  * “View Recognition Logs” to go to the Admin Recognition Logs Screen.
* **Stats Refresh:** If the dashboard displays summary stats, the admin might pull-to-refresh or tap a refresh icon to update the numbers (though real-time sync can do it automatically, manual refresh ensures up-to-date).
* There are typically no data input fields here, mostly navigation. Possibly if we allow, the admin might have an “Add new breed” shortcut here (but that’s more appropriate in Breed management screen). Better to keep dashboard as simple navigation.

**Outputs:**

* **Admin Greeting:** It might say “Welcome, \[Admin Name]” as a simple header, confirming they are in admin mode.
* **Section Links:** Clear buttons or cards for each main admin section:

  * A **Breeds** card showing something like “Breeds: X breeds in database” (where X is the count of breed entries).
  * A **Facts** card showing “Facts: Y facts in database”.
  * A **Recognition Logs** card showing something like “Z recognition attempts logged”. Possibly with a note if any recent ones, e.g., “5 new today” (if we want to indicate recent activity).
* **Summary Stats:** As mentioned, each card can include a numeric summary:

  * **Total Breeds** count (so admin knows how many breeds are currently listed).
  * **Total Facts** count.
  * **Total Recognition Logs** count (or perhaps logs in the last 24 hours, whichever is more meaningful – but likely total or just some idea of volume).
* **Navigation UI:** A simple layout where tapping anywhere on a card or button leads to the respective screen. The output is mostly static info and buttons, as the real data management happens in subsequent screens.
* **Error/Permission Notice:** If by any chance a non-admin user navigated here (should not be possible via UI since we hide it, but say they manually typed a route), the screen could output an “Access Denied” message and show nothing else. But ideally admin check prevents showing the screen at all. Mention for completeness: Only admin sees this content.

**Navigation:**

* **Entry:** This screen is accessible only to admin users (after sign-in). Typically, the Profile screen for an admin might have a button that navigates here. The app verifies the user’s admin status (maybe by checking a field in the user profile or a claim in the token) before allowing access. If user is not admin, they should not reach this. The admin dashboard might also be a separate area of the app toggled by role. In any case, an admin will click “Admin Panel” or similar to arrive here.
* **Exit:**

  * Selecting any section sends the admin to that specific management screen (Breeds, Facts, or Logs).
  * The admin can use the back button to return to the Profile or main app (exiting admin area).
  * From the admin screens, back often returns to this dashboard for convenience (e.g., after editing something, going back might land on the dashboard or directly back to profile depending on navigation structure). Possibly it's a nested stack under admin. We'll assume back from a management screen goes to the dashboard.
  * The admin can also use global nav to go to user-facing parts of the app (they still can use the breed encyclopedia, etc., as a normal user). The admin dashboard might not be accessible except through profile or a special route, so the admin toggles between user view and admin view as needed.

**Functionality:**

* **Admin Check:** On navigating to Admin Dashboard, the app should confirm the user’s credentials. Likely, when the user logged in, the app already determined they have admin rights (e.g., by checking their email against a list or a flag in Firestore). This screen should maybe double-check or be protected by a route guard. If for some reason the user lost admin status (maybe removed in DB in the meantime) or token doesn’t have it, this screen should either not load data and show an error, or immediately restrict access. But typically, admin status doesn’t fluctuate often.
* **Fetch Summary Data:** The dashboard may gather some quick stats:

  * Count of breed entries: could be obtained via a lightweight query (Firestore can count documents if using an aggregate query, or we could have stored counts in some “stats” document). Or the app might fetch the breed list and count length (since breed list likely not too large, it could just count client-side if data is possibly already loaded from earlier usage).
  * Count of facts: similarly.
  * Count of logs: If logs are numerous, we might not fetch all just to count. Better to use a Firestore count function or maintain a count. But for simplicity, maybe just fetch last 100 logs for viewing and count those or approximate. If an exact count isn't trivial, the UI might omit it or just show “View Recognition Logs” without number. But a number is nice. We can assume usage is moderate so counting isn't too heavy.
  * Alternatively, the admin screens themselves will show lists where they can see counts, so showing counts on dashboard is just convenience.
* **Real-time updates:** If an admin is looking at the dashboard while another admin adds a breed from elsewhere, Firestore could in theory trigger updates to the counts if using real-time listeners. That’s a small detail. At minimum, a refresh will update counts. Possibly implement listeners on each collection count, but that might be overkill – manual refresh or re-entering screen could be enough for an admin.
* **Navigation functions:** Tapping a section is straightforward route navigation:

  * Breed card -> push Breed Management screen.
  * Fact card -> push Fact Management screen.
  * Logs card -> push Logs screen.
* **Error Handling:** If any of the count queries fail or data fetch fails (maybe network issues), the dashboard should still show the section buttons so admin can navigate, but perhaps display “–” or “N/A” for the counts or an error icon. Possibly a toast “Could not load summary, but you can still manage data.” Because even if counts fail, admin can try going into the sections which will attempt to load the actual data.
* **Offline Notes:** If offline, the dashboard might not be able to fetch fresh counts. However, if the admin has been in those sections before, some data might be cached:

  * The breed count could be derived from cached breeds in local from the user side (the admin might have the same cached breed list the user uses). If offline, showing the last known count is possible if data in cache. Firestore’s offline cache could allow counting locally stored docs, but it doesn’t provide a direct count API offline. We could load cached documents to count but that’s heavy for logs if many.
  * Regardless, offline, the admin likely can still navigate into Breeds or Facts management and view cached data (and even make changes that queue until online). But the dashboard counts might be stale. Perhaps mark them with something (or just not worry too much).
  * The admin dashboard can function offline to navigate to sections if data is cached. It should inform if an action absolutely needs connectivity (like viewing logs might require online if not cached).
  * In summary, offline mode: The admin dashboard loads using cached counts if possible or shows whatever it can. Admin can go into Breeds/Facts and see cached content and even add/edit (with offline sync). For logs, if offline, likely none or only older cached logs would show (less useful).
* **Security:** Ensure that only admin sees this. This might involve Firebase Security Rules as well (like the collections might only be writable by admin accounts). The app UI is an extra layer to hide it from normal users. If a normal user somehow tries to access an admin route, it should check and redirect them out.
* **No direct data manipulation here:** The dashboard itself doesn’t alter data, it’s just for navigation and overview. So no data validation issues except making sure the displayed counts are correct integers.

## Admin Breed Management Screen

**Purpose:** Allow the admin to view the list of all cat breeds in the database and manage them (create new breeds, edit existing ones, or possibly delete if needed). This is the administrative interface corresponding to the user’s Breed Encyclopedia, giving full CRUD control over breed entries.

**Inputs:**

* **Breed List Selection (Edit):** The admin taps on a breed in the list to edit its details. This triggers navigation to the Admin Breed Edit Screen for that specific breed.
* **Add New Breed:** The admin taps an “Add Breed” button (often a floating action button with a “+” icon, or a menu option) to create a new breed entry. This navigates to the Admin Breed Edit Screen in a creation mode (empty form).
* **Delete Breed:** If deletion is allowed, the admin triggers a delete action for a breed. This could be via a swipe on the list item (swipe left to reveal “Delete”), or a long-press context menu “Delete”, or a delete icon next to each breed. Any delete action should prompt confirmation (“Are you sure you want to delete this breed?”) before finalizing.
* **Search Breeds (optional):** If there are many breeds, an admin might have a search bar to quickly find one by name. Inputting text filters the list similar to the user-side.
* **Sort/Filter (optional):** Could have sorting options (alphabetical, by date added, etc.), but not necessary given moderate number of breeds. Likely default alphabetical is fine. If needed, the admin could use search rather than requiring sort toggles.

**Outputs:**

* **Complete Breed List:** A scrollable list of all breed entries. Each list item might display the breed’s name and perhaps a small thumbnail image for identification. Possibly also some key detail like origin, so the admin can differentiate similar names (if two breeds have similar names, origin might help).
* **Add Button:** A visible button (like a “+” icon floating) to add a new breed.
* **Deletion UI:** If deletion is provided, a confirmation dialog output as mentioned when triggered. After deletion, the list updates (the breed disappears).
* **Status/Success Messages:** After certain actions, brief feedback:

  * If a breed was added or updated and returns to this screen, a toast might say “Breed saved successfully.”
  * If a breed was deleted, maybe a toast “Breed deleted.”
    These are not mandatory but improve admin UX.
* **Error Messages:** If something fails (e.g., failed to load list, or a deletion error), show an error at top or toast: “Failed to load breeds, check connection” or “Error deleting breed.”
* **Loading Indicator:** When first loading the list (or refreshing), show a spinner or progress bar. Also, if we support pull-to-refresh, that shows a typical refresh indicator.

**Navigation:**

* **Entry:** Accessed from Admin Dashboard by tapping “Manage Breeds.” It could also be returned to after saving a breed (the flow: dashboard -> breed list -> breed edit -> back to breed list).
* **Exit:**

  * Tapping a breed goes to **Admin Breed Edit Screen** for that breed.
  * Tapping “Add Breed” goes to **Admin Breed Edit Screen** in new entry mode.
  * Using back navigation returns to the Admin Dashboard.
  * The admin can also navigate away via main menu to user sections if needed.
  * After an edit or add is completed and the admin returns (via back or save flow), they come back here to see the updated list.
* **Deep linking:** Not needed for user, but maybe for admin, they could come directly here if they always manage content (but they’d still log in and navigate normally).

**Functionality:**

* **Data Fetching:** On entering this screen, fetch the list of all breeds from the database (likely Firestore). This is similar to what the user sees, but possibly including any breeds that are hidden or in-progress (if such concept existed, but likely not). It should retrieve at least the name and perhaps minimal info for listing (images not necessarily needed except maybe thumbnail, but the admin might want to see images to ensure they uploaded correctly). If storing image URLs, the admin list could load the thumbnail via URL; if that’s heavy, could skip images in list and just show names. Up to design.

  * Firestore allows real-time updates; we might attach a listener so that if any breed is added/edited by another admin or via other device, the list auto-updates. Useful in multi-admin scenario, though probably rare to have many admins.
  * If we use the same collection as user side, the admin is basically reading that. There might be more fields in admin view (like draft status, etc., but not specified). We assume all fields are same.
* **Search:** If implemented, filter logic as per user side – likely client-side filter on the loaded list. No complex query needed unless the number of breeds is huge (not in this domain).
* **Add Breed Navigation:** The “Add Breed” button sets up a new blank breed object (or just navigates and the edit screen will know it’s a new entry mode). The admin will then enter details and save.
* **Delete Breed:**

  * When initiated, confirm intention. If confirmed, the app will remove the breed document from Firestore and any associated image file from Storage.
  * After deletion, the list should update (the item disappears). If using real-time listeners, the removal auto-reflects; if not, we might manually remove it from the local list upon success.
  * **Data Integrity:** Deleting a breed should also handle related data. For instance, user favorites referencing that breed need cleanup. Ideally, we would implement a Cloud Function to listen for breed deletion and remove that breed from any favorites lists, or the app could do a query to find any user who favorited it and update them (but that’s complex on client side). A simpler approach: We can disallow deletion if that breed is in use, or proceed and accept that favorites might point to a non-existent breed (which the app should handle by ignoring missing references). For SRS, mention: *When a breed is deleted, it should be removed from users’ Favorites lists or those references should be cleaned up to avoid orphan favorites.* Possibly implemented by a backend process.
  * Also, recognition logs that refer to that breed (as a predicted result) will remain as historical data; that’s fine, no need to purge logs. But if a breed is deleted and was in logs, the log just shows a breed name that no longer exists in the encyclopedia. Not a big issue.
  * We mention these considerations so developers know to handle them.
* **Error Handling:**

  * If breed list fails to load (maybe due to permission or network), show an error and perhaps allow retry. Possibly if offline, we use cached list (see offline notes).
  * If deletion fails (network or permission error), show an error message. The item should remain in the list if not truly deleted. Possibly re-enable the delete option so they can try again when connection is back.
  * If an edit from the edit screen fails to save, that screen handles it; this list screen may not even know unless we choose to refresh the list after an edit (which if using real-time or returning after save, it’ll show updated data).
* **Offline Notes:**

  * Viewing: If the admin has loaded the breeds list before, it can be available offline via cache. They will see the list (maybe not any new ones since last online). They can open breed details to view (if those were cached or not? If not cached, the edit screen might have blanks or have to wait for connection to fetch the breed doc – but if we loaded list of all breeds, presumably we got each doc’s data anyway, so it might be enough to populate the edit form offline).
  * Adding/Editing offline: Firestore offline persistence means the admin can attempt to add or edit a breed without connectivity; the changes will be saved locally and sync when back online.

    * However, images are a special case: uploading a photo to Firebase Storage will **not** succeed offline (there’s no offline queue for storage uploads). So if an admin tries to add a breed with an image offline, the text data could be queued but the image upload would fail immediately. We likely should restrict image uploads to online only. Perhaps disable the Save button or inform the admin if they attempt to save a new breed offline that includes an image that it cannot upload until online.
    * If admin still saves offline with image, maybe we store the text part in Firestore (which will sync) but the image is missing. The admin would have to upload the image later when online (maybe via editing that entry). This is complicated for user; better to advise “No internet, cannot upload images. Please connect or save without images.” But a breed without an image is incomplete in this app's context (since user likely expects an image). So likely, the admin should do this when online.
  * Editing text fields offline (like updating description) could be queued and sync later seamlessly.
  * Deletion offline: Deletion of a doc can be queued by Firestore as well. It likely will mark it deleted locally and remove from cache, then sync the delete when online. So the admin might see it gone locally. But if image deletion is also needed, that’s a problem because deleting from Storage cannot happen offline either. So the breed doc deletion will sync later to Firestore, but the image file will remain in storage until some manual or deferred deletion occurs. We could note: *Image files associated with deleted breeds should be removed from storage to free space (this may require an online operation; possibly handled by a backend function triggered by breed deletion).*
  * So offline admin actions on data are partially supported (text via Firestore caching) but images and some cleanups are not until online. The app should either restrict those or handle accordingly.
  * For SRS, we can note these limitations.
* **Data Validation:**

  * We ensure breed names are unique: The admin interface ideally should prevent adding a duplicate breed name. Perhaps when saving a new breed, the app can check existing names (client side: a quick check in loaded list). If duplicate found, warn admin and refuse save or ask to confirm. Uniqueness is important as it’s the key by which users identify breeds. (Even if two names could technically be same if they refer to variations, but let’s assume unique).
  * If an admin tries to add a breed with a name that differs only in case or spacing, might treat that as duplicate too to avoid confusion.
  * Ensure required fields are not empty: name, description, etc. The Breed Edit screen will handle this validation and not allow save if invalid. The management list just displays whatever is there. If a breed entry lacks an image, we might show a placeholder or marker (so admin knows missing image).
  * Possibly enforce certain formats (like life span in a “X - Y years” format, or numeric fields 1-5 for traits) – these rules can be documented to admin or validated in the form.
* **Real-time update:** If one admin adds a breed and another admin is on this screen on another device, they should see it pop in (Firestore listener triggers UI update). Not vital, but nice concurrency support.

## Admin Breed Edit Screen

**Purpose:** Provide a detailed form for the admin to enter or modify all information about a cat breed. This is where the admin inputs the data that end-users will see in the Breed Detail. It supports both creating new breed entries and editing existing ones.

**Inputs:** The form fields likely include:

* **Breed Name:** *(Text input)* The name of the breed. *(Required, unique)*
* **Description:** *(Multiline text input)* A thorough description of the breed.
* **Origin:** *(Text input)* The country or region of origin. Possibly a dropdown if we restrict to known countries, but text is fine for flexibility.
* **Life Span:** *(Text or numeric range input)* The average or range of life expectancy (e.g., “12 - 15 years”). We might use two numeric fields (min and max years) or one text field. Simpler might be text for admin, but need consistency. Alternatively, two fields and then display as “X–Y years”.
* **Temperament:** *(Text input)* A comma-separated list or just a sentence of temperament keywords (e.g., “Affectionate, Playful, Intelligent”). Admin can format it how they like, or separate checkboxes for common traits (but that’s complex; text is easier).
* **Trait Ratings:** We likely have several fields for numeric ratings (1 to 5). For example:

  * Adaptability (1-5)
  * Affection Level (1-5)
  * Child Friendly (1-5)
  * Grooming Needs (1-5)
  * Intelligence (1-5)
  * Health Issues (1-5) – presumably a rating of how prone to health issues (maybe 5 means more issues or less? Need clarity but admin should know the convention used by app).
  * Social Needs (1-5)
  * Stranger Friendly (1-5)
    These correspond to the traits we show in comparison. The admin can input these as dropdowns or spinners with values 1 through 5. They should default to a value (perhaps 1 or 3) if not set. (If admin leaves it blank, treat as 0 or handle that as missing – better to require these or default them).
* **Weight/Size:** (Optional) If the app wants to store typical weight or size, not explicitly mentioned but some breed info includes that. Could have fields like “Weight (kg or lbs)” in a range. Not specified, so we can skip or include if we want detail. Not necessary given prompt, so skip for brevity.
* **Alternate Names:** (Optional text) Some breeds have alternate names; not mentioned but if desired.
* **Image Upload:** The admin should upload one or more images of the breed. Likely at least one primary image. We’ll assume one image required per breed for now. So:

  * **Breed Image:** *(File input)* The admin can select an image file from their device. In Flutter, this would open a file picker or camera (the admin might have images on their computer if using web, or on device if mobile; likely an admin might do this from a desktop if the app ran on web or just use their phone’s gallery).
  * Once selected, maybe show a preview thumbnail in the form so they know it’s loaded.
  * If editing an existing breed, it might show the current image and have an option to change it (replace).
  * Possibly allow multiple images? Not requested. For simplicity, one image per breed. If multiple needed in future, the admin UI would have to allow adding multiple and reordering, which complicates things. We'll stick to one main image.
* **Save Button:** The admin taps “Save” to commit changes.
* **Cancel Button:** The admin taps “Cancel” or back to discard changes.
* **Delete (maybe):** If we didn’t allow delete via list, maybe a delete button here. If an admin opens a breed and wants to remove it, a Delete action could be inside this screen. If so, it should confirm and then perform deletion similar to above. But since we covered deletion in list, we might not need it here too. Could have redundancy though (some UIs allow deletion in edit view as well).
* The form should mark required fields (name, likely description, image) so admin knows they must fill those.

**Outputs:**

* **Form Pre-population:** If editing an existing breed, all the fields are filled with the current data from the database. If adding a new breed, fields are blank/default.
* **Image Preview:** If an image is selected or if editing (with an existing image URL), display a small preview. For existing image, could show a thumbnail with a label “Current image” and maybe a “Change Image” button to select a new one.
* **Validation Messages:** If the admin tries to save but some required field is missing or invalid, the form should highlight that field and perhaps show an error message like “Name is required” or “Please enter a unique breed name”. Similarly, if a numeric field is out of expected range, show error (e.g., if admin typed 6 for a 1-5 field, or letters where number expected).
* **Confirmation of Save:** After a successful save, perhaps a small toast “Saved” can appear. On save, typically the screen might automatically navigate back to Breed Management list, where that toast could appear. Or it could remain on form and show a message “Changes saved” – but usually better to go back to list to confirm listing. We'll assume it goes back to list on success (common pattern).
* **Delete Confirmation:** If a delete button exists in this screen, triggering it outputs a confirmation dialog “Delete this breed? This action cannot be undone.” If confirmed, it performs deletion, then likely navigates back to the list (with that breed gone).
* **Progress Indicator:** When the admin hits Save, especially if an image is being uploaded, a progress UI should appear (like a spinner and “Saving…” text) to indicate work in progress. This remains until the operation completes. If the image upload is large, perhaps even a progress bar if we track bytes (not required but helpful for large files).
* **Error Messages on Save:** If saving fails:

  * Couldn’t upload image (network down): show “Image upload failed. Please check connection and try again.”
  * Couldn’t write to Firestore (e.g., permission or network): “Failed to save breed. Please try again.”
  * Duplicate name validation: “A breed with this name already exists. Please use a different name.”
  * These errors might be inline or pop-up alerts. Possibly just a simple dialog or toast.
* **Offline Warning (if applicable):** If admin is offline and they open this screen, maybe a banner “You are offline. You can edit text fields, but image upload will not work until you’re online.” This is an optional helper to set expectation. At least, if they try to pick an image offline and hit save, handle accordingly.

**Navigation:**

* **Entry:**

  * From Breed Management: if admin tapped a breed, enters edit mode with that breed’s data.
  * From Breed Management: if tapped “Add Breed”, enters new-breed mode (all fields empty).
  * Possibly accessible via a deep link if needed (like an “edit” button on breed detail if we allowed that, but we didn't mention it. The admin likely uses this panel, not the user detail, to edit).
  * The screen should clearly indicate whether it’s “New Breed” or editing existing (maybe by title: “Add Breed” vs “Edit Breed: \[Name]”).
* **Exit:**

  * On tapping Save and if successful, typically navigate back to Breed Management screen (and possibly show a toast as mentioned).
  * On Cancel/back without saving, confirm if there are unsaved changes: The app should warn “Discard changes?” if fields have been modified. If confirmed or no changes, it goes back to Breed Management list.
  * If deletion is done here, after delete, navigate back to list (maybe skipping the list’s confirm because we already confirmed in this screen).
  * The admin can also back out at any time using device back; if changes were made, same unsaved changes prompt should appear.
* **Prevent leaving mid-save:** While uploading/saving, ideally disable navigation (to avoid user backing out and causing partial save issues). Or if they do, maybe cancel the operations. It's more of an implementation detail, but we mention that saving is atomic from user perspective (they either wait for success or get an error; not leave in middle).

**Functionality:**

* **Load Data:** If editing, fetch the breed record from Firestore (if not passed along). However, since the Breed Management list likely had the data, it could be passed to this form to avoid another fetch. But if not, this screen should query the breed by ID from database and populate fields. Ensure to handle loading state while data arrives.
* **Unique Name Check:** On adding a new breed, the app should ensure the name isn’t already taken. This can be done:

  * Client-side: compare with the list of names from Breed Management (which we likely have in memory).
  * Server-side: could also be enforced by a Firestore rule or a query (like query by name to see if any exists).
  * For immediate feedback, client-side is fine. If an admin types a name that’s in use, we can show error as they leave the field or upon Save attempt.
* **Field Validation:**

  * Required fields: Name, Description, and likely an Image should be considered required (the app feels incomplete without an image, but we might allow saving without one if they want to add later; better to require an image though for quality).
  * Numeric fields: restrict input to 1-5. If using text fields for those (not ideal), at least validate and coerce or error. Preferably use a picker UI for those to ensure valid values.
  * Text fields (Origin, Temperament, etc.): can be free text, but ensure not extremely long (we can trust admin to input reasonable lengths, but maybe enforce a max length like 100 chars for origin, 500 or 1000 for description, etc., to avoid performance issues).
  * Image file: validate that a file is selected for a new breed (if required). If editing, not required to change but ensure there's an existing image or a new one selected.
  * Possibly image type and size: restrict to common image formats (jpg, png) and perhaps enforce a max file size (for example, if admin tries a huge 10MB image, maybe compress it or instruct them to use a smaller one). We can automatically resize images in the app before upload to a manageable resolution (like 1024px width) to save space and bandwidth. This might be an implementation detail, but it's good to mention optimizing images to keep app efficient.
* **Save Process (New or Edit):**

  * If new: The app will create a new document in Firestore (with a new unique ID). Steps:

    1. Upload image to Firebase Storage (in a designated folder, e.g., “breed\_images/\[breedID].jpg”). Perhaps use the breed name or generated ID for file naming.
    2. Get the URL or storage path of the uploaded image.
    3. Create the breed document with all fields including that image URL. The document’s key could be the new ID from Firestore’s add function or you set it as the breed name (not recommended if names have spaces and to allow duplicates in future, but could use name as ID if we trust uniqueness. Better to use auto ID or a slug).
    4. Ensure the data writes successfully.
    5. Possibly update any cross-references (if any, likely none except logs or something, but no cross-ref needed on creation).
    6. On success, the new breed will propagate to user view (the next time users fetch, or immediately if using listeners).
  * If edit existing:

    1. If a new image is selected (changed): upload the new image. Optionally, delete the old image from storage to free up space (could be done now or later; perhaps do it now if not in use elsewhere).
    2. Update the Firestore document with all new field values, and the new image URL if changed (or keep old if not changed).
    3. Save operation might use Firestore “set” or “update” method. After success, the changes propagate to the user’s Breed Encyclopedia (if they are online and listening or next fetch).
    4. If image changed and old image was removed, ensure no references to old image remain. (We might just do a storage delete after updating Firestore).
  * We must handle these sequences carefully so that if image upload fails, we don’t wrongly update DB, etc. Usually, do image first, then data.
  * Firestore and Storage operations should have appropriate security rules: ensure only admin can write. We assume admin’s credentials allow it (maybe by their UID in rules).
* **Cancel/Unsaved Changes:** If the admin inputs things but then goes back or hits cancel:

  * The app should detect unsaved changes. We can track initial state vs current state. If any field was modified or image selected, prompt: “You have unsaved changes. Discard them and exit?” If yes, revert and go back; if no, stay on form.
  * If nothing changed, just go back without prompt.
* **Delete Breed (if on this screen):**

  * If provided here, similar to before: confirm, then:

    * Delete Firestore document.
    * Delete breed image from storage.
    * Possibly trigger a clean-up of favorites containing this breed (maybe a Cloud Function; if not, those favorites will point to nowhere – the app should be robust to handle missing breed references by skipping them).
  * On success, maybe a toast “Breed deleted” and navigate back to Breed list (which now no longer has it). If failure, show error.
* **Offline and Save:**

  * If admin is offline and hits Save:

    * The Firestore update/add will be queued and eventually sync (if offline persistence is on). The admin’s device will behave as if it saved (the doc will appear in local cache).
    * However, the image upload will fail immediately because Storage cannot queue offline. The app should detect no connection before trying to upload and either prevent saving or save without image (not good) or queue text changes only.
    * Perhaps better: disable the Save button or the image field if offline, or display a warning that saving fully is not possible offline. If admin still attempts, we could do: skip image upload, just save text? But then the breed will have a missing image URL – incomplete data. That’s not desirable as it breaks user experience.
    * Likely approach: require connectivity to add a new breed (since it needs an image). For editing, if they are just editing text and not changing image, that could be allowed offline (the text will sync later fine). But we should caution them that if they changed image, it won’t upload.
    * Possibly if image changed offline, we store the new image path locally but can't upload. The admin would have to manually re-add image when online. This is too complicated to manage.
    * So for simplicity, we say: Admin should be online for any operations involving images (new breed or changing image). If offline, either disallow those actions or treat as partial.
    * The app can check connectivity at save: if offline and an image upload is pending, show an alert “Cannot upload image while offline. Please connect to the internet to save this breed.” and do not proceed. If offline but no image change (just text changes to an existing breed), we could allow it to queue. In that case, we save the text updates offline (will sync automatically) and skip image since none changed. That’s actually fine. So we can allow text-only edits offline.
    * So implement:

      * If offline and new breed (image required) -> block.
      * If offline and editing with image unchanged -> allow (text sync).
      * If offline and editing but image was changed -> block with warning.
  * Summarize in SRS: *Admin breed edits require internet for image uploads. Text-only edits can be saved offline and will sync later, but the UI should notify the admin that changes are pending and only visible to them until online.* However, Firestore caching will make it visible in their app, but not to others or other devices until sync.
  * Also, if an admin adds a breed offline (if we allowed it without image, which we probably don’t), regular users won’t see it until that admin goes online and syncs, which could cause confusion. So better to not add offline with incomplete data.
* **Feedback on Save:** Provide clear feedback, e.g., after tapping save and finishing, navigate out with a message. If staying on screen (some apps remain on edit after saving so you can continue editing), they might show a "Saved" message in place. But it's more common to go back to list to see all entries.

## Admin Fact Management Screen

**Purpose:** Let the admin view and manage the collection of cat facts. The admin can add new facts or edit existing ones, ensuring the content for the Cat Fact Hub is up-to-date and appropriate.

**Inputs:**

* **Fact List Selection (Edit):** The admin taps on a specific fact in the list to edit its content (opens Admin Fact Edit Screen).
* **Add New Fact:** The admin taps an “Add Fact” button (maybe a floating +) to create a new fact entry. Navigates to Admin Fact Edit Screen in new fact mode.
* **Delete Fact:** The admin triggers deletion of a fact, via swipe or a delete icon. Confirm prompt before deletion.
* **Search Facts (optional):** If many facts, a search field might filter by keywords contained in the fact text. Given facts are likely short, this might not be necessary, but could be helpful if hundreds of facts and admin wants to ensure no duplicates or find if a certain fact exists.

**Outputs:**

* **List of Facts:** A list of all fact entries, possibly sorted by creation date or alphabetically by some key (though facts are just text, maybe chronological order of entry makes sense, or no particular order if daily selection is random). For admin convenience, maybe show newest facts at top. Each list item may display the beginning of the fact text (if it's long, truncated). If facts are short (one sentence), the whole fact might fit. If facts can be multi-sentence, perhaps just first sentence or first 50 characters.
* **Add Button:** A visible button to add a new fact.
* **Confirmation & Toasts:** Similar to breed management: confirmation dialog on delete, and toast messages on successful add/edit (“Fact saved”) or deletion (“Fact deleted”).
* **Error Message:** If loading fails or operations fail, show errors. E.g., “Failed to load facts” or “Error deleting fact.”
* **Loading Indicator:** Show a spinner while loading the facts list initially or on refresh.

**Navigation:**

* **Entry:** From Admin Dashboard, tapping “Manage Facts”. Could also be returned to after an edit or add.
* **Exit:**

  * Tapping a fact -> **Admin Fact Edit Screen** for that fact.
  * Tapping Add -> **Admin Fact Edit Screen** for new fact.
  * Back navigation -> returns to Admin Dashboard.
  * (Alternatively, if we allow editing in place in list? Unlikely, easier to use separate screen.)
* After saving or deleting, the admin comes back here (assuming the design to always return to list after changes).
* If admin navigates away to other app sections, they leave as normal.

**Functionality:**

* **Fetch Facts:** On load, retrieve all facts from Firestore (e.g., a “facts” collection). The data for each fact could include: an ID, the text content, maybe a date or metadata. We presumably store just text and maybe an auto-generated ID. If admin entered facts on different dates, those documents have creation timestamps which could be used to sort by newest if needed.

  * Real-time updates: If one admin adds a fact, another’s list updates live via listener. Could implement similarly to breed list.
* **Display List:** Show each fact entry as a list item. Possibly include an index number or short title if facts are long. If facts are one-liners, the list can just be a series of those lines, which might be fine as is. If they are paragraph length, maybe each entry show first line with ellipsis.
* **Add Fact:** On clicking add, navigate to Fact Edit form.
* **Edit Fact:** On clicking a fact, navigate to Fact Edit form pre-filled.
* **Delete Fact:** Confirm, then remove the fact document from Firestore. There's no extra data like images associated with facts (unless we had images, but we don’t). So deletion is straightforward.

  * Impact of deletion: If we were scheduling facts by date, deletion could disrupt scheduling, but since we are likely random or sequential without fixed dates, it just reduces the pool by one. If the daily selection logic is e.g. index mod count, removing a fact changes indices for subsequent ones, but that’s fine.
  * No user-facing direct link to a fact that would break (unless a user happened to have today's fact which got deleted mid-day – then if they refresh maybe they'd get a different fact or none; but it's an edge case likely negligible).
* **Data Validation:**

  * Ensure fact text is not empty. (Required)
  * Possibly trim whitespace.
  * Maybe have a max length (maybe enforce something like <= 500 characters to keep facts reasonably short).
  * Ensure uniqueness? If we want to avoid duplicate facts, admin might need to search manually or we could do a quick check of identical text existing. Could do a simple check: compare new fact text with existing list to see if identical (case-insensitive) exists. If yes, warn "Duplicate fact exists." But not mandatory, up to admin diligence. We can mention it as a possible thing to avoid duplicates.
* **Save (Add/Edit) Fact** in the Fact Edit screen will handle the details, but from list perspective:

  * After adding, the new fact appears in the list (possibly at top if sorted by new). Maybe the list auto-updates if using a listener or we manually insert it.
  * After editing, the changed text should update in the list. Real-time listeners or a manual refresh when returning can update it.
* **Error Handling:**

  * If facts list fails to load (network or permission), show error and possibly allow retry (pull to refresh or a retry button).
  * If deletion fails, show error and keep the item.
  * If an edit fails to save (in edit screen), that screen will handle it; the list just won't update.
* **Offline Notes:**

  * Viewing: If the admin loaded facts earlier, they are cached; offline, they can see the last known list. Possibly fine.
  * Adding/Editing offline: Firestore will queue text write operations, so the admin could add or edit facts offline and it will sync later. Because facts are just text, this is simpler than breeds (no images).

    * However, if admin adds a fact offline, other users won’t get it until sync, which is expected. The admin might see it in their cached list immediately, but it's marked pending in local. That’s fine.
    * So offline add/edit is feasible. We might allow it with minimal hindrance.
  * Deletion offline: Also possible (it will queue deletion to sync). The admin will see it gone from their list locally (the doc is marked removed locally). When online, it will actually delete on server.

    * One caveat: if a user’s app tries to fetch that fact in the interim (like if that fact was going to be fact-of-day for someone), since the deletion isn’t on server yet, they still could get it. Once admin goes online, it will remove for future. That’s fine.
  * Summary: Admin Fact management works fairly well offline for text because everything can sync later without external dependencies. The UI should perhaps indicate when things are queued (but not necessary; just trust Firestore).
* **One fact per day logic (admin perspective):** The admin does not need to assign facts to dates. They just manage a pool. We might instruct that no need to worry about scheduling; the app picks facts automatically. If the admin wants a certain fact to show on a particular day, our system doesn’t directly allow that unless we design it (which we didn’t). They could if desperate remove others or something. But since the prompt said not gamified and presumably random daily, it’s fine. We won’t complicate with scheduling UI.

## Admin Fact Edit Screen

**Purpose:** Provide a simple interface for the admin to create a new fact or edit an existing fact’s text content.

**Inputs:**

* **Fact Text Field:** *(Multiline text input)* The content of the cat fact. This is the main and only piece of data for a fact. (No images or other metadata for facts in our scope.) The admin types or modifies the fact text here. Required field.
* **Save Button:** The admin taps “Save” to confirm saving the fact.
* **Cancel/Back:** The admin can cancel the operation by going back or tapping a cancel action, discarding changes.
* **(Delete Button optional):** If we allow deletion from within the edit screen (some UIs include a delete option here as well as in list), the admin could tap a delete icon to remove this fact. This would prompt confirmation similar to doing it from the list.

**Outputs:**

* **Form Pre-population:** If editing an existing fact, the text field is pre-filled with that fact’s current text. If adding a new fact, the field is empty (or maybe a placeholder like “Enter cat fact…”).
* **Validation Indicators:** If the admin tries to save without entering any text, the field should highlight and perhaps show “Fact text is required.” Similarly, if text exceeds some max length (if we set one), it could show an error or prevent further typing beyond limit.
* **Save Confirmation:** On successful save, likely navigate back to the Fact Management list and maybe show a toast there (“Fact saved”). Alternatively, we could stay on this screen and clear it for another input, but typically for these UIs, after saving one fact, you return to list. We'll go with returning to list after save.
* **Error Message:** If saving fails, a popup or inline message: “Failed to save fact. Please try again.” Could also highlight if any specific issue (like duplicate, but duplicates likely not auto-detectable unless we did it manually).
* **Delete Confirmation:** If a delete action is present here, confirm similarly. On confirm, delete the fact, then navigate back to list with a message.
* **Unsaved Changes Prompt:** If the admin has typed something but not saved and tries to cancel/back, output a prompt “Discard unsaved changes?” to avoid accidental loss.

**Navigation:**

* **Entry:**

  * From Fact Management list: selecting a fact (edit mode) or tapping add (new mode).
  * The screen title could be “Edit Fact” or “New Fact” accordingly to inform admin.
* **Exit:**

  * On Save success -> go back to Fact list.
  * On Cancel/back -> go back to Fact list (with prompt if unsaved input).
  * On Delete (if done here) -> after confirming and deletion, back to list.
* The admin can also possibly navigate to other sections, but presumably they'd save or cancel first. If they do abruptly leave (like switching app section without hitting back, not typical if it's a push route; they'd have to back out anyway on mobile. On web, they could click another UI element maybe; in that case unsaved will be lost unless we handle it).

**Functionality:**

* **Load Data:** If editing, likely the fact text was passed from the list to avoid needing to fetch it again. But if not, this screen could query Firestore for that fact ID. It's probably easier and faster to pass it since we had it in list.
* **Input:** Provide a multiline text box. Possibly allow newlines if facts can be multi-sentence. (Some facts could be two sentences, that’s fine.)
* **Character Limit:** We might impose a limit (e.g., 300 chars). If so, maybe show a counter. It's not strictly necessary but ensures push notifications or UI isn't too large, however since we aren't doing push and the UI can scroll, it's fine to allow reasonably long facts. But cat facts usually one or two sentences.
* **Validation:**

  * Non-empty check: do not allow saving an empty fact.
  * Trim whitespace on save (so that just spaces isn't considered content).
  * If desired, check for duplicate: we could search the existing facts list to see if exactly the same text exists. If yes, warn admin "This fact seems similar to an existing one." But not required by user story, so skip unless we want to be thorough.
  * If a maximum length is decided, enforce it (stop accepting input beyond it or show error).
* **Save Fact:**

  * If new: create a new Firestore document in facts collection with the provided text. Possibly also store a timestamp (Firestore will auto timestamp on creation if needed).
  * If editing: update the existing document’s text field with the new content.
  * These are simple single-field writes. Should be quick and unlikely to fail except network issues.
  * Firestore rules: ensure only admin can write, which should be set.
  * After saving, the changes reflect in user app: if a user’s device queries a random fact, they might now get the updated text if that fact is selected. If a user had the fact open (not likely as they don’t browse like that) or cached, next time they fetch, they'd get updated data.
* **Delete Fact (if provided here):**

  * Delete the document from Firestore. No other data to worry about (no references elsewhere except logs maybe referencing a fact? We did not mention any logs for facts, and likely not needed. And facts aren't used anywhere else).
  * After deletion, it’s removed from the admin’s list (and will no longer be served to users because it’s gone).
  * If at the moment a user’s daily fact was the one deleted, and if the user hadn’t fetched it yet, depending on how selection works, maybe the app might not find it and pick another or just fail. But such a race condition is edge. Possibly the user’s app might have cached it; if they open offline after admin deleted, they might see it (since cached) even though it’s “deleted.” That's minor.
* **Cancel/Back (Unsaved changes):**

  * Keep track if the text field has been changed (compare current text with original loaded text). If changed and not saved, on navigation attempt, show confirm dialog as described.
  * If confirmed to discard, just pop without saving. If not, stay on form.
* **Offline Support:**

  * The admin can edit facts offline easily since it’s text:

    * If adding a fact offline: Firestore will queue that new doc. The admin’s local list will show it (maybe flagged as pending internally, but UI just sees it there). It will sync when online.
    * If editing a fact offline: Firestore will queue the update. Locally, the fact is updated in cache (so admin sees it updated). It will sync to server when online, so eventually users see it.
    * If deleting offline: Firestore will queue deletion. Locally, it likely hides the doc immediately (depending on the library’s behavior). So the admin list will drop it and it will be gone for that admin, syncing actual deletion when online.
  * So offline is quite feasible for facts management because no external dependencies like images.
  * The UI might not even need to treat offline specially except to catch the case of network failure on save:

    * If using offline persistence, calling Firestore .add/.update will succeed locally immediately (triggering success callback) even if offline, because it’s cached. So the app might think “saved” and navigate back. Firestore will sync later. This is okay, but the admin should realize it’s pending if they notice not showing on other devices, etc. Possibly we might show an icon on the list item if it's not synced, but that’s an extra detail. We can mention it or just not worry.
    * If no persistence (but by default it is on mobile), then offline writes would error. We assume persistence is enabled on the app for all these reasons.
  * Conclusion: offline add/edit/delete for facts are supported by underlying tech. We'll mention that changes will sync when back online, and admin can manage facts offline (except they won't propagate to users until online).
* **Error Handling:**

  * If .add or .update actually fails (like due to permission - maybe if admin’s token expired or not authorized), handle that error. Possibly reauth or just error message and not pop the screen.
  * If no connection and for some reason persistence is off, it would error. But we assume on, so it might not error, it would just queue.
  * If an error occurs, keep the admin on the form to retry rather than navigating away.
* **User Feedback:**

  * On successful save, we return to list and possibly highlight new/edited entry or just show it updated. A toast "Fact saved" can reassure the admin. Similarly for delete.
  * If an admin is adding multiple facts in one session, one might want a “Save and Add Another” option to streamline data entry, but not necessary. They can just repeat the process by hitting add again from list.
* **No images, no additional metadata:** So it's a straightforward text form.

---

**Data Validation Requirements (Summary):**

* All user input fields have basic validation. Breed Name and Fact text are required and not empty. Breed names should be unique among breeds (the system or admin must ensure no duplicates). Numeric trait fields for breeds must be within 1-5 (the UI will constrain this). Image files must be of acceptable type/size; the app may resize large images for performance. Fact text should ideally be concise (the system may impose a reasonable character limit). Admin input forms will enforce these rules before allowing save.

**Error Handling Notes (Summary):**

* The app provides user-friendly error messages for network failures (e.g., “Please check your internet connection” on data fetch or save errors). If an AI recognition fails or yields no result, the result screen informs the user (“Breed not identified” or error code). Navigation to admin screens by non-admin users is blocked with an appropriate message or redirect to main screen. The system confirms destructive actions (like deletions) to prevent accidental data loss. In case of any operation failing (data save, image upload, etc.), the app will not silently fail – it will notify the user/admin and allow retry or cancellation as appropriate.

* On the user side, if network is unavailable:

  * Breed Encyclopedia: uses cached data if available, otherwise shows a warning that data is unavailable offline.
  * Breed Detail: uses cache if available; if not, error message or partial data.
  * Favorites: if offline, shows cached favorites; adding/removing favorites will update locally and sync later.
  * Recognition: if offline (and using cloud AI), the app will prevent starting analysis and prompt for connection (since the AI call won’t work offline). If using on-device AI, offline is fine but that's an implementation choice.
  * Cat Facts: if offline, shows last fetched fact if cached; if not, informs user to connect for new facts.

* On the admin side:

  * Admin screens will detect offline state. Viewing lists (breeds, facts, logs) works from cache if available. Creating or editing data offline will be queued by Firestore and sync when online, but the UI will caution about limitations (especially image uploads requiring connectivity). The admin should ideally perform image-related operations only when online to ensure they complete. Text changes can be done offline and will auto-sync.

**Offline/Data Sync Notes:**

* The app utilizes Firebase’s offline persistence for Firestore, meaning read/write operations on cached data will succeed and sync automatically when the device reconnects. This allows users to browse previously loaded breed info and facts without internet, and even queue actions like favoriting a breed or an admin editing text data offline.
* However, certain features require connectivity by nature:

  * Google Sign-In cannot be done offline at all (user must be online to authenticate).
  * The Cat Recognition AI is assumed to be a cloud service; thus, recognition requires internet. If the user is offline, the app will disable or postpone the recognition function (e.g., display a message “Internet required for this feature”). If an on-device ML model is used instead, recognition can work offline, but by default we expect online.
  * Uploading images (for breed data) requires internet. Admin attempts to upload images offline will fail or be deferred. The app will encourage doing those actions online to avoid data inconsistency.
* Data synchronization:

  * User favorites: Stored in Firestore under the user’s account. The app will sync any favorite added/removed offline once back online, so the cloud data remains consistent. Users on multiple devices will see favorites update since it’s cloud-backed.
  * Breed & fact updates by admin: When an admin adds/edits data, all user clients will get updated data on next fetch (if using Firestore with listener or when they refresh). The app could use Firestore real-time updates to push changes to users actively using the app (e.g., if a new breed is added, it could appear in the list without app update). At minimum, the next time users open the app or refresh that section, they get the new data.
  * Recognition logs: If offline when a log entry is attempted to be recorded, it will sync later. But recognition itself likely wouldn't run offline, so logs are mostly an online scenario. If logs are cached, admin can still view old logs offline.
* The system avoids any data corruption by validating inputs and handling error states. It uses transactions or atomic operations where needed (though our use-cases are simple enough to not require multi-doc transactions except maybe if we simultaneously update breed count somewhere, which we aren’t explicitly doing).

Finally, all these requirements are aligned with implementing the app in Flutter with Firebase:

* We’ll use Flutter widgets for form inputs, lists, image picking, etc., and FlutterFire plugins for Firebase integration (Auth, Firestore, Storage).
* Firebase Authentication manages Google Sign-In and user identity.
* Cloud Firestore stores breeds, facts, and logs with offline persistence enabled by default on mobile.
* Firebase Storage holds breed images.
* No external social features: the design is entirely single-user oriented, and no data is shared between users except through the common content managed by admin (there’s no user-to-user interaction required).
* The admin panel may be part of the same app (just conditionally shown) rather than a separate app, which is fine given the solo nature. Only those flagged as admin will see those screens.

This SRS covers all user-facing and admin functionalities for *PurrfectPedia*, providing a clear blueprint for development and ensuring the app’s features meet the specified requirements. Each screen’s behavior and interactions have been detailed to be developer-ready for implementation.
