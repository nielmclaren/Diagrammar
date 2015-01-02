
class FileNamer {
  int currIndex;
  String prefix;
  String extension;

  FileNamer() {
    currIndex = 0;
    prefix = "export";
    extension = "";
  }

  FileNamer(String _prefix, String _extension) {
    currIndex = 0;
    prefix = _prefix;
    extension = _extension;
  }

  String curr() {
    return getFilename(currIndex);
  }

  String next() {
    File file;
    while ((file = new File(sketchPath(getFilename(currIndex)))).exists() && currIndex < 1000) {
      currIndex++;
    }
    return getFilename(currIndex);
  }

  private String getFilename(int n) {
    String s = prefix + nf(n, 4);
    if (extension == null || extension == "") return s;
    if (extension == "/") return s + extension;
    return s + "." + extension;
  }
}
