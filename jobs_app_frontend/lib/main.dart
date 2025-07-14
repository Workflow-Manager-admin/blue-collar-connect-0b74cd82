import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';
import 'providers/jobs_provider.dart';
import 'providers/applications_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/messaging_provider.dart';
import 'api/models.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_web_plugins/url_strategy.dart' as web_plugins;
import 'dart:io' show Platform;

/// Set up web compatibility and responsive design from main entry
void main() {
  // Set path-based routing for web
  try {
    web_plugins.usePathUrlStrategy();
  } catch (_) {
    // Ignore exceptions if running on non-web platforms.
  }
  runApp(const BlueCollarConnectRoot());
}

// Entry point that sets up global Providers for networking/integration
class BlueCollarConnectRoot extends StatelessWidget {
  const BlueCollarConnectRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => JobsProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MessagingProvider()),
      ],
      child: const BlueCollarConnectApp(),
    );
  }
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
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        minWidth: 360,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.autoScale(360, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.autoScale(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
        background: Container(color: const Color(0xFFF5F5F5)),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF583400),
          secondary: const Color(0xFFa77b00),
          tertiary: const Color(0xFFFFB300),
          surface: const Color(0xFFF5F5F5),
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF583400),
          secondary: const Color(0xFFa77b00),
          tertiary: const Color(0xFFFFB300),
          surface: Colors.black,
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  // Use Provider for authentication state
  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    if (!session.isAuthenticated) {
      return OnboardingScreen(onSignedIn: () {
        // Simulate sign-in (demo token or just pass any string)
        session.signIn('demo-token');
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

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On first build, auto-fetch core app data.
    if (!_initialized) {
      Provider.of<JobsProvider>(context, listen: false).fetchJobs();
      Provider.of<ApplicationsProvider>(context, listen: false).fetchApplications();
      Provider.of<MessagingProvider>(context, listen: false).fetchThreads();
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
      _initialized = true;
    }
  }

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

/// Jobs list and search screen.
/// Integrates the provider and renders real data from the backend.
class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {
            // (Optional) Implement search feature
          }),
          IconButton(icon: const Icon(Icons.map_outlined), onPressed: () {
            // (Optional) Implement map view
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await jobsProvider.fetchJobs(),
        child: Builder(
          builder: (_) {
            if (jobsProvider.isLoading && jobsProvider.jobs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (jobsProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Error loading jobs: ${jobsProvider.error}",
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      onPressed: () => jobsProvider.fetchJobs(),
                    ),
                  ],
                ),
              );
            }
            final jobs = jobsProvider.jobs;
            if (jobs.isEmpty) {
              return const Center(
                child: Text("No jobs found.", style: TextStyle(color: Colors.grey)),
              );
            }
            return ListView.separated(
              itemCount: jobs.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, i) {
                final job = jobs[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      child: const Icon(Icons.work, color: Colors.white),
                    ),
                    title: Text(job.title),
                    subtitle: Text(job.companyName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => JobDetailsScreen(jobId: job.id),
                      ));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Job Details Screen that wires up live data and apply-to-job.
class JobDetailsScreen extends StatelessWidget {
  final String jobId;
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);
    final job =
        jobsProvider.jobs.firstWhere((j) => j.id == jobId, orElse: () => Job(
              id: jobId,
              title: "Loading...",
              companyId: "",
              companyName: "",
              location: "",
              description: "",
              salary: "",
              applied: false,
            ));

    return FutureBuilder(
      future: job.companyName.isEmpty ? jobsProvider.fetchJobs() : Future.value(),
      builder: (context, snapshot) {
        final isLoading = jobsProvider.isLoading && job.companyName.isEmpty;
        final hasError = jobsProvider.error != null && job.companyName.isEmpty;

        if (isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Job Details")),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error loading job: ${jobsProvider.error}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    onPressed: () => jobsProvider.fetchJobs(),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(job.title)),
          body: Padding(
            padding: const EdgeInsets.all(22),
            child: ListView(
              children: [
                Text(
                  job.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(job.companyName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                const SizedBox(height: 16),
                const Text(
                  "Job Description:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(job.description ?? "No description provided."),
                const SizedBox(height: 16),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: const Text("Location"),
                  subtitle: Text(job.location),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money_outlined),
                  title: const Text("Salary"),
                  subtitle: Text(job.salary ?? "TBD"),
                ),
                const SizedBox(height: 18),
                Builder(
                  builder: (context) {
                    final isApplying = jobsProvider.isLoading;
                    return ElevatedButton.icon(
                      icon: isApplying
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.assignment_turned_in_outlined),
                      label: Text(job.applied
                          ? "Already Applied"
                          : isApplying
                              ? "Applying..."
                              : "Apply for Job"),
                      onPressed: (job.applied || isApplying)
                          ? null
                          : () async {
                              final result =
                                  await jobsProvider.applyToJob(job.id);
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Application sent!")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(jobsProvider.error ?? "Error")),
                                );
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
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
/// Renders real application data and states from API via provider.
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final applicationsProvider = Provider.of<ApplicationsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Applications')),
      body: RefreshIndicator(
        onRefresh: () async => await applicationsProvider.fetchApplications(),
        child: Builder(builder: (context) {
          if (applicationsProvider.isLoading && applicationsProvider.applications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (applicationsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: ${applicationsProvider.error}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    onPressed: () => applicationsProvider.fetchApplications(),
                  ),
                ],
              ),
            );
          }
          final applications = applicationsProvider.applications;
          if (applications.isEmpty) {
            return const Center(
              child: Text("No applications yet.", style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            itemCount: applications.length,
            padding: const EdgeInsets.all(10),
            separatorBuilder: (_, __) => const SizedBox(height: 5),
            itemBuilder: (context, i) {
              final a = applications[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in, color: Color(0xFFa77b00)),
                  title: Text("Application #${a.id}"),
                  subtitle: Text("Status: ${a.status}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Messaging screen with chats fetched from backend.
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final messagingProvider = Provider.of<MessagingProvider>(context);

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
      body: RefreshIndicator(
        onRefresh: () async => await messagingProvider.fetchThreads(),
        child: Builder(builder: (context) {
          if (messagingProvider.isLoading && messagingProvider.threads.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (messagingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: ${messagingProvider.error}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    onPressed: () => messagingProvider.fetchThreads(),
                  ),
                ],
              ),
            );
          }
          final threads = messagingProvider.threads;
          if (threads.isEmpty) {
            return const Center(
              child: Text("No messages yet.", style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            itemCount: threads.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, i) {
              final thread = threads[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: Text(thread.contactName),
                subtitle: thread.messages.isNotEmpty
                    ? Text(thread.messages.last.text,
                        overflow: TextOverflow.ellipsis)
                    : const Text("No messages yet.", style: TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(
                      threadId: thread.id,
                    ),
                  ));
                },
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* Compose message */},
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.edit),
      ),
    );
  }
}

/// User profile screen (view and basic edit, using real backend data).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

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
      body: RefreshIndicator(
        onRefresh: () async => await profileProvider.fetchProfile(),
        child: Builder(builder: (context) {
          if (profileProvider.isLoading && profileProvider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileProvider.error != null && profileProvider.profile == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: ${profileProvider.error}",
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    onPressed: () => profileProvider.fetchProfile(),
                  ),
                ],
              ),
            );
          }
          final user = profileProvider.profile;
          if (user == null) {
            return const Center(child: Text("No profile data.", style: TextStyle(color: Colors.grey)));
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFa77b00),
                backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null ? const Icon(Icons.person, color: Colors.white, size: 55) : null,
              ),
              const SizedBox(height: 18),
              Center(child: Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              const SizedBox(height: 7),
              Center(child: Text(user.email, style: const TextStyle(fontSize: 14, color: Colors.grey))),
              if ((user.bio ?? "").isNotEmpty) ...[
                const SizedBox(height: 14),
                Center(child: Text(user.bio!, style: const TextStyle(fontSize: 15))),
              ],
              const SizedBox(height: 26),
              _buildProfileOption(context, 'Edit Profile', Icons.edit, () {}),
              _buildProfileOption(context, 'My Network', Icons.people_alt_outlined, () {}),
              _buildProfileOption(context, 'Saved Jobs', Icons.bookmark_outline, () {}),
            ],
          );
        }),
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

/// Chat details for a specific thread, loading and sending real messages.
class ChatDetailScreen extends StatefulWidget {
  final String threadId;
  const ChatDetailScreen({super.key, required this.threadId});
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(MessagingProvider provider) async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _sending = true);
    await provider.sendMessage(widget.threadId, _controller.text.trim());
    _controller.clear();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessagingProvider>(context);
    final thread = provider.threads
        .firstWhere(
          (t) => t.id == widget.threadId,
          orElse: () => MessageThread(
            id: widget.threadId,
            contactName: "Unknown",
            messages: const [],
          ),
        );

    return Scaffold(
        appBar: AppBar(title: Text(thread.contactName.isNotEmpty ? thread.contactName : "Chat")),
        body: Column(
          children: [
            if (provider.isLoading && thread.messages.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else ...[
              Expanded(
                child: thread.messages.isEmpty
                    ? const Center(child: Text("No messages yet.", style: TextStyle(color: Colors.grey)))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final m in thread.messages)
                            Align(
                              alignment: m.senderId == "me" // Replace with proper user state if available
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ChatBubble(isFromMe: m.senderId == "me", text: m.text),
                            ),
                        ],
                      ),
              ),
            ],
            if (provider.error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Error: ${provider.error}", style: const TextStyle(color: Colors.red)),
              ),
            _buildMessageInputBar(provider),
          ],
        ));
  }

  Widget _buildMessageInputBar(MessagingProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: Colors.grey.shade100,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Type your message..."),
              enabled: !_sending,
              onSubmitted: (_) => _sendMessage(provider),
            )),
            const SizedBox(width: 7),
            _sending
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(width: 25, height: 25, child: CircularProgressIndicator(strokeWidth: 2)))
                : IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFa77b00)),
                    onPressed: () => _sendMessage(provider),
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

