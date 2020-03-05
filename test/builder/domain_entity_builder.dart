abstract class DomainEntityBuilder<T> {
  T build() {
    return buildList().first;
  }

  List<T> buildList();
}
