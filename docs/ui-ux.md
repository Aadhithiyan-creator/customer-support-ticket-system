# UI/UX configuration

The deployed app provides navigation, object layout, and list views. Complete these org-specific Lightning App Builder steps to create the polished home and record pages:

## App and home page

1. Open **Setup → App Manager**, edit **Field Sales App**, and confirm navigation: Home, Support Tickets, Accounts, Contacts, Tasks, Reports, Dashboards.
2. Open **Setup → Lightning App Builder → New → Home Page**. Name it **Customer Support Ticket Intelligence**. Choose a responsive two-column template with a wide primary column.
3. Add a Rich Text welcome panel titled “Customer Support Ticket Intelligence” with subtitle “AI-powered ticket prioritization and automated support assignment”. Use the standard Lightning styling and restrained brand color.
4. Create reports for Ticket Counts by Priority, Tickets by Status, Recent Tickets, High Priority Tickets, and Open Tickets by Assigned Agent. Use `Support_Ticket__c` as the report type. Add a dashboard with summary metric and donut/bar charts; place Dashboard and Report Chart components on the home page.
5. Add the Recent Tickets list view and High Priority Tickets list view using List View components. Show Ticket Number, Customer, Priority, Status, Assigned Agent, and Created Date.
6. Add standard actions for New Support Ticket, Log a Call, New Task, New Case, and New Lead in the page's supported action area. If an action is unavailable for this custom object context, add it to the app utility bar or global publisher layout.
7. Add a Rich Text explanatory section for Agentforce assistance and add the Agentforce component only if licensed and enabled. Activate the page as the app default for the intended support app.

## Ticket record page

1. In **Lightning App Builder**, create/edit a Support Ticket record page and assign it to the support app.
2. Use a two-column record template. Keep the Highlights Panel and record actions at top; add Related Record for Account/Contact where useful.
3. Group details into Ticket Information, Issue Details, Resolution, and Activity. Place Activity Timeline and related Tasks/Calls in the activity column.
4. Put Priority, Status, and Assigned Agent in the top section. Use the standard picklist component and compact layout; avoid custom CSS. Configure conditional visibility on supported components for High priority escalation messaging.
5. Add standard New Task, Log a Call, and New Case actions where supported. Activate for the intended app/profile audience.

The custom object layout and list views in metadata are the deployable base. Home dashboard report IDs, activation assignments, action layouts, and Agentforce widgets are deliberately configured in the target org rather than guessed in metadata.
