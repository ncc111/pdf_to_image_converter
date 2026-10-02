import os

def verify_consolidation(directory, output_filename):
    expected_total_lines = 0
    actual_lines = 0
    
    output_filepath = os.path.join(directory, output_filename)
    
    # Count lines in original files
    print("Counting lines in original files...")
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        
        # Skip the output file itself and directories
        if filename == output_filename or not os.path.isfile(filepath):
            continue
            
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                # splitlines() handles different newline conventions and trailing newlines correctly
                lines = f.read().splitlines()
                count = len(lines)
                expected_total_lines += count
                # print(f"{filename}: {count} lines") # Uncomment for debugging
        except Exception as e:
            print(f"Error reading {filename}: {e}")

    # Count lines in the consolidated file
    print("Counting lines in consolidated file...")
    if os.path.exists(output_filepath):
        try:
            with open(output_filepath, 'r', encoding='utf-8', errors='ignore') as f:
                actual_lines = len(f.read().splitlines())
        except Exception as e:
            print(f"Error reading consolidated file: {e}")
    else:
        print(f"Error: {output_filepath} not found.")
        return

    print("-" * 30)
    print(f"Expected total lines: {expected_total_lines}")
    print(f"Actual lines in output: {actual_lines}")
    print("-" * 30)

    if expected_total_lines == actual_lines:
        print("SUCCESS: All rows appear to be consolidated correctly!")
    else:
        difference = actual_lines - expected_total_lines
        print(f"WARNING: Line count mismatch! Difference: {difference}")
        if difference > 0:
            print("The consolidated file has more lines than the sum of individual files (this might be due to the added newlines).")
        elif difference < 0:
            print("The consolidated file has fewer lines than the sum of individual files.")

if __name__ == "__main__":
    target_dir = r"C:\Users\IvanNG\Desktop\1MIN"
    output_file = "consolidated_output.txt"
    verify_consolidation(target_dir, output_file)
