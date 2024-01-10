  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email);
  }

    String getAppBarTitle(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Tickets';
      case 2:
        return 'My Jobs';
      default:
        return 'Home';
    }
  }

  