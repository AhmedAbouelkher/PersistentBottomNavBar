part of persistent_bottom_nav_bar;

class BottomNavStyle19 extends StatelessWidget {
  final NavBarEssentials? navBarEssentials;

  BottomNavStyle19({
    Key? key,
    this.navBarEssentials = const NavBarEssentials(items: null),
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected, double? height) {
    if (this.navBarEssentials!.navBarHeight == 0) {
      return SizedBox.shrink();
    } else {
      final _height = height! / 1.2;
      return AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        width: isSelected ? 120 : 50,
        height: _height,
        duration: navBarEssentials!.itemAnimationProperties?.duration ?? Duration(milliseconds: 400),
        curve: navBarEssentials!.itemAnimationProperties?.curve ?? Curves.ease,
        // padding: EdgeInsets.all(item.contentPadding),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? item.activeColorPrimary : navBarEssentials!.backgroundColor!,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Row(
          children: <Widget>[
            _buildTitleSection(height, isSelected, item),
            _buildTitle(item, isSelected),
          ],
        ),
      );
    }
  }

  Widget _buildTitleSection(
    double height,
    bool isSelected,
    PersistentBottomNavBarItem item,
  ) {
    final iconThemeData = IconThemeData(
        size: item.iconSize,
        color: isSelected
            ? (item.activeColorSecondary == null ? item.activeColorPrimary : item.activeColorSecondary)
            : item.inactiveColorPrimary == null
                ? item.activeColorPrimary
                : item.inactiveColorPrimary);
    final icon = IconTheme(
      data: iconThemeData,
      child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
    );
    if (!isSelected) return icon;
    return Container(
      constraints: BoxConstraints.tight(Size.square(height / 1.45)),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 0),
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: .1,
          ),
        ],
      ),
      child: icon,
    );
  }

  Widget _buildTitle(PersistentBottomNavBarItem item, bool isSelected) {
    if (item.title == null || !isSelected) return const SizedBox.shrink();
    return Expanded(
      child: Container(
        color: Colors.amber,
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              item.title!,
              style: item.textStyle?.merge(
                TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: this.navBarEssentials!.navBarHeight,
        padding: this.navBarEssentials!.padding == null
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.07,
                vertical: this.navBarEssentials!.navBarHeight! * 0.15,
              )
            : EdgeInsets.only(
                top: this.navBarEssentials!.padding?.top ?? this.navBarEssentials!.navBarHeight! * 0.15,
                left: this.navBarEssentials!.padding?.left ?? MediaQuery.of(context).size.width * 0.07,
                right: this.navBarEssentials!.padding?.right ?? MediaQuery.of(context).size.width * 0.07,
                bottom: this.navBarEssentials!.padding?.bottom ?? this.navBarEssentials!.navBarHeight! * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.navBarEssentials!.items!.map((item) {
            int index = this.navBarEssentials!.items!.indexOf(item);
            return Flexible(
              flex: this.navBarEssentials!.selectedIndex == index ? 2 : 1,
              child: GestureDetector(
                onTap: () {
                  if (this.navBarEssentials!.items![index].onPressed != null) {
                    this.navBarEssentials!.items![index].onPressed!(this.navBarEssentials!.selectedScreenBuildContext);
                  } else {
                    this.navBarEssentials!.onItemSelected!(index);
                  }
                },
                child: _buildItem(
                  item,
                  this.navBarEssentials!.selectedIndex == index,
                  this.navBarEssentials!.navBarHeight,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
