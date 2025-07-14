import 'package:flutter/material.dart';

void main() {
  runApp(const BlueCollarConnectApp());
}

/// The main app for Blue Collar Connect.
///
/// Sets up theme, color scheme, and tabbed navigation.
/// Scaffolds all major UI screens for future backend integration.
// PUBLIC_INTERFACE
class BlueCollarConnectApp extends StatelessWidget {
  const BlueCollarConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blue Collar Connect',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF583400),
          secondary: const Color(0xFFa77b00),
          tertiary: const Color(0xFFFFB300),
          surface: const Color(0xFFF5F5F5), // Replaces deprecated background
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF583400),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          surfaceTintColor: Color(0xFFF5F5F5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFa77b00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF583400),
          secondary: const Color(0xFFa77b00),
          tertiary: const Color(0xFFFFB300),
          surface: Colors.black, // Replaces deprecated background
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF583400),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF1F1F1F),
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          surfaceTintColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFa77b00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AppRoot(),
    );
  }
}

/// The root widget controlling onboarding/auth, then main tabs.
// PUBLIC_INTERFACE
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    // Placeholder: Show onboarding/auth if not authenticated
    if (!isAuthenticated) {
      return OnboardingScreen(onSignedIn: () {
        setState(() {
          isAuthenticated = true;
        });
      });
    }
    return const TabbedMainShell();
  }
}

/// Onboarding/Authentication Navigation Entry.
///
/// This screen wraps onboarding and auth (future: show intro, or go to Auth).
class OnboardingScreen extends StatelessWidget {
  final VoidCallback onSignedIn;
  const OnboardingScreen({super.key, required this.onSignedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.handyman_outlined, size: 60, color: Color(0xFFa77b00)),
              const SizedBox(height: 24),
              const Text(
                "Welcome to Blue Collar Connect!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Join or sign in to discover, apply, and connect for blue-collar jobs.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Sign In / Register"),
                onPressed: () {
                  // Navigate to AuthScreen (stub, for now success auto-login)
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AuthScreen(onAuthenticated: onSignedIn),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Authentication (Sign In/Sign Up) flow placeholder.
class AuthScreen extends StatelessWidget {
  final VoidCallback onAuthenticated;
  const AuthScreen({super.key, required this.onAuthenticated});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In / Register")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 70, color: Color(0xFFa77b00)),
            const SizedBox(height: 20),
            const Text("Sign in / Create your account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: ElevatedButton(
                onPressed: onAuthenticated,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 8),
                    Text("Continue (Demo Auth)"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("More authentication features coming soon...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

/// Main tabbed navigation shell for all primary features.
class TabbedMainShell extends StatefulWidget {
  const TabbedMainShell({super.key});

  @override
  State<TabbedMainShell> createState() => _TabbedMainShellState();
}

class _TabbedMainShellState extends State<TabbedMainShell> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    JobsScreen(),
    ApplicationsScreen(),
    MessagesScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined), label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.work_outline), label: "Jobs"),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined), label: "Applications"),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline), label: "Messages"),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline), label: "Profile"),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined), label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary.withAlpha(140),
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) {
          setState(() => _selectedIndex = newIndex);
        },
      ),
    );
  }
}

// ----- Page Stubs ------

/// Main dashboard/home screen with featured jobs/posts.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildCard("Today’s Jobs for You", Icons.bolt, const Color(0xFFFFB300)),
          _buildCard("Latest Updates", Icons.info_outline, const Color(0xFFa77b00)),
          _buildCard("Browse Categories", Icons.category_outlined, const Color(0xFF583400)),
        ],
      ),
    );
  }
  Widget _buildCard(String title, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}

/// Jobs list and search screen with filter and search bar.
class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.map_outlined), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(vertical: 8),
        separatorBuilder: (_, __) => const SizedBox(height: 2),
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              child: const Icon(Icons.work, color: Colors.white),
            ),
            title: Text('Job Position #${i+1}'),
            subtitle: const Text('Company A'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => JobDetailsScreen(
                  jobTitle: 'Job Position #${i+1}',
                  companyName: 'Company A',
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}

/// Job Details Placeholder Wireframe
class JobDetailsScreen extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  const JobDetailsScreen({super.key, required this.jobTitle, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(jobTitle)),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: ListView(
          children: [
            Text(
              jobTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              companyName,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Job Description:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text("Details about the job position will appear here."),
            const SizedBox(height: 16),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.place_outlined),
              title: Text("Location"),
              subtitle: Text("To be integrated..."),
            ),
            const ListTile(
              leading: Icon(Icons.attach_money_outlined),
              title: Text("Salary"),
              subtitle: Text("TBD"),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              icon: const Icon(Icons.assignment_turned_in_outlined),
              label: const Text("Apply for Job"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Notifications Screen Placeholder
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: List.generate(
            6,
            (i) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications_active, color: Color(0xFFFFB300)),
                    title: Text("Notification #${i + 1}"),
                    subtitle: Text("Notification message ${i + 1}..."),
                  ),
                )),
      ),
    );
  }
}

/// Applications status and management screen.
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: ListView.separated(
        itemCount: 5,
        padding: const EdgeInsets.all(10),
        separatorBuilder: (_, __) => const SizedBox(height: 5),
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.assignment_turned_in, color: Color(0xFFa77b00)),
            title: Text('Application #${i+1}'),
            subtitle: Text('Status: ${["Pending", "Viewed", "Interview", "Offer", "Rejected"][i]}'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }
}

/// Messaging screen with chats.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: "Notifications",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ));
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Text('Contact Name ${i + 1}'),
          subtitle: const Text('Last message preview...'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChatDetailScreen(
                contactName: 'Contact Name ${i+1}',
              ),
            ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* Compose message */},
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.edit),
      ),
    );
  }
}

/// User profile screen (view and basic edit stub).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFFFB300)),
            tooltip: "Notifications",
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFa77b00),
            child: Icon(Icons.person, color: Colors.white, size: 55),
          ),
          const SizedBox(height: 18),
          const Center(child: Text('User Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 7),
          const Center(child: Text('worker@email.com', style: TextStyle(fontSize: 14, color: Colors.grey))),
          const SizedBox(height: 26),
          _buildProfileOption(context, 'Edit Profile', Icons.edit, () {}),
          _buildProfileOption(context, 'My Network', Icons.people_alt_outlined, () {}),
          _buildProfileOption(context, 'Saved Jobs', Icons.bookmark_outline, () {}),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}

/// Settings & preferences screen (stub).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsOption(context, 'App Theme', Icons.brightness_6, () {}),
          _buildSettingsOption(context, 'Notifications', Icons.notifications_active, () {}),
          _buildSettingsOption(context, 'Logout', Icons.logout, () {}),
        ],
      ),
    );
  }
  Widget _buildSettingsOption(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}

/// Company details (for when a job/company tile is tapped).
// PUBLIC_INTERFACE
class CompanyDetailsScreen extends StatelessWidget {
  final String companyName;
  const CompanyDetailsScreen({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(companyName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business, color: Theme.of(context).colorScheme.primary, size: 60),
            const SizedBox(height: 12),
            Text(
              companyName,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            const Text("Company details coming soon...", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// Chat details for a specific contact.
class ChatDetailScreen extends StatelessWidget {
  final String contactName;
  const ChatDetailScreen({super.key, required this.contactName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contactName)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ChatBubble(isFromMe: false, text: "Hi, are you available for a job interview?"),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ChatBubble(isFromMe: true, text: "Yes, I'm interested!"),
                ),
              ],
            ),
          ),
          _buildMessageInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: Colors.grey.shade100,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: TextField(decoration: const InputDecoration(hintText: "Type your message..."))),
            const SizedBox(width: 7),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFFa77b00)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple chat bubble widget for the messaging screen.
class ChatBubble extends StatelessWidget {
  final bool isFromMe;
  final String text;
  const ChatBubble({super.key, required this.isFromMe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: isFromMe
            ? Theme.of(context).colorScheme.tertiary.withAlpha((0.8 * 255).toInt())
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: TextStyle(color: isFromMe ? Colors.white : Colors.black87)),
    );
  }
}

