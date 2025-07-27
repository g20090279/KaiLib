import time

# A function that we will use to test stepping through the code
def count_up_to(limit):
    for i in range(1, limit + 1):
        print(f"Counting: {i}")  # Here we can set a breakpoint
        time.sleep(1)

# Another function for testing
def complex_calculation(x, y):
    result = x * y + 3
    print(f"Result of complex calculation: {result}")
    return result

# Main entry point
def main():
    print("Starting program...")

    result = complex_calculation(10, 5)  # Another place to test stepping
    print(f"Final result: {result}")
    
    print("Program finished.")

if __name__ == "__main__":
    main()

