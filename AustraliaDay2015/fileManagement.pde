
void writeTextFile() {

  //Create string for saving to text file
  String[] listString = new String[index];
  for (int i = 0; i < index; i++) {
    listString[i] = join(nf(int(data[i]), 0), ",");
  }

  //Save to text file
  saveStrings("list.txt", listString);
}
