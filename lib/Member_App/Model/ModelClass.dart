class Menu {
  final String Icon;
  final String IconName;
  final String IconLabel;

  Menu({this.Icon, this.IconName, this.IconLabel});

  static List<Menu> allMenuItems() {
    var listofmenus = new List<Menu>();

    listofmenus.add(new Menu(
        Icon: "DailyHelp.png", IconName: "DailyHelp", IconLabel: "Daily Help"));
    listofmenus.add(new Menu(
        Icon: "information.png", IconName: "Notice", IconLabel: "Notice"));
    listofmenus.add(new Menu(
        Icon: "complaint.png",
        IconName: "Complaints",
        IconLabel: "Complaints"));
    listofmenus.add(new Menu(
        Icon: "directory.png", IconName: "Directory", IconLabel: "Directory"));

    listofmenus.add(new Menu(
        Icon: "mySociety.png", IconName: "MySociety", IconLabel: "My Society"));
    listofmenus.add(new Menu(
        Icon: "emergency.png", IconName: "Emergency", IconLabel: "Emergency"));
    listofmenus.add(new Menu(
        Icon: "polling.png", IconName: "Polling", IconLabel: "Polling"));
    listofmenus.add(new Menu(
        Icon: "gallery.png", IconName: "Gallery", IconLabel: "Gallery"));

    // listofmenus
    //     .add(new Menu(Icon: "bill.png", IconName: "Bills", IconLabel: "Bills"));
    listofmenus.add(new Menu(
        Icon: "Utilities.png", IconName: "Amenities", IconLabel: "Amenities"));
    listofmenus.add(new Menu(
        Icon: "event_society.png", IconName: "Events", IconLabel: "Events"));
    listofmenus.add(new Menu(
        Icon: "Vendors.png", IconName: "Vendors", IconLabel: "Vendors"));
    listofmenus.add(new Menu(
        Icon: "reminder.png", IconName: "Reminders", IconLabel: "Reminders"));

    return listofmenus;
  }
}
