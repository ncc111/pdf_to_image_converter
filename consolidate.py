import os

def consolidate_files(directory, output_filename):
    # Get all files in the directory
    files = [os.path.join(directory, f) for f in os.listdir(directory) 
             if os.path.isfile(os.path.join(directory, f)) and f != output_filename]

    # Sort files by modification time (ascending)
    files.sort(key=os.path.getmtime)

    print(f"Found {len(files)} files. Sorting by date and consolidating...")

    with open(os.path.join(directory, output_filename), 'w', encoding='utf-8') as outfile:
        for filepath in files:
            filename = os.path.basename(filepath)
            print(f"Processing: {filename}")
            try:
                with open(filepath, 'r', encoding='utf-8', errors='ignore') as infile:
                    content = infile.read()
                    outfile.write(content)
                    # Add a newline after each file's content to ensure they don't merge incorrectly
                    if not content.endswith('\n'):
                        outfile.write('\n')
            except Exception as e:
                print(f"Error reading {filename}: {e}")

    print(f"Consolidation complete. Output saved to: {os.path.join(directory, output_filename)}")

if __name__ == "__main__":
    target_dir = r"C:\Users\IvanNG\Desktop\1MIN"
    output_file = "consolidated_output.txt"
    consolidate_files(target_dir, output_file)
