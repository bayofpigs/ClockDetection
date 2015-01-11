import glob, os

def rename(dir, pattern):
  output = r'data%03d'
  counter = 1
  for pathAndFilename in glob.iglob(os.path.join(dir, pattern)):
      title, ext = os.path.splitext(os.path.basename(pathAndFilename))
      print ext
      os.rename(pathAndFilename, 
                os.path.join(dir, output % counter + ".jpg"))
      counter = counter + 1

def main():
  rename(r'./images', r'*')

if __name__ == '__main__':
  main()
