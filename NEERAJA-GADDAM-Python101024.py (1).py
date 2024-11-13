""" Scenario Overview:
 You are tasked with developing a Library Management System for a medium-sized library. The system should be able to manage Books, Members, and their borrowing activities. 
 The focus of the case study is on applying Object-Oriented Programming (OOP) principles like encapsulation, inheritance, and polymorphism, along with effective use of Exception Handling (both built-in and user-defined exceptions).

 The system should allow members to borrow and return books while keeping track of the availability of books in the library. Additionally, the system must restrict the number of books a member can borrow simultaneously, which will require custom exception handling.

 Functional Requirements:

 Books:
 Each book should have a unique ID, a title, an author, and a status indicating if it is available or borrowed.
 The system should allow new books to be added to the library's collection.
 Books should be categorized as fiction or non-fiction.


 Members:

 Members should have a unique ID, a name, and a record of the books they have borrowed.
 There should be two types of members: Regular and Premium. Regular members can borrow up to 3 books at a time, while Premium members can borrow up to 5 books.
 Members should have methods to borrow and return books, and the system should update the status of the book accordingly.

 Library:

 The library should maintain a collection of books and handle book lending and returns.
 The library should keep track of which books are currently available and which are borrowed.
 Borrow and Return System:

 A member can borrow a book if it is available.
 When a book is borrowed, its availability status must be updated, and the borrowing must be recorded in the member’s profile.
 When a book is returned, the status must be updated, and the record should be removed from the member’s profile.


 Non-Functional Requirements:
 Exception Handling:

 The system must handle cases where a member tries to borrow a book that is already borrowed.
 The system must also handle scenarios where a member tries to borrow more books than they are allowed (Regular or Premium).
 Use both built-in exceptions (e.g., ValueError, IndexError) and create a user-defined exception for when a member exceeds their borrowing limit.
 Scalability:

 The system should be designed to handle an expanding list of members and books, and manage borrowing activities efficiently.
 Data Validation:

 Ensure data is valid when adding new books and members, and handle cases where invalid data is entered (e.g., a blank book title or member name).
 Object-Oriented Design:
 Class: Book

 Attributes:
 book_id: Unique identifier for each book.
 title: Title of the book.
 author: Author of the book.
 status: Availability status (available or borrowed).
 Methods:
 __init__(): Initialize the book attributes.
 borrow(): Change the book’s status to borrowed.
 return_book(): Change the book’s status to available.
 Class: Member

 Attributes:
 member_id: Unique identifier for each member.
 name: Name of the member.
 borrowed_books: A list of books currently borrowed by the member.
 max_books: Maximum number of books the member can borrow (3 for Regular, 5 for Premium).
 Methods:
 __init__(): Initialize the member’s attributes.
 borrow_book(): Allow the member to borrow a book, with exception handling for availability and borrowing limit.
 return_book(): Allow the member to return a borrowed book.

 Class: Library

 Attributes:
 book_collection: A collection of all books in the library.
 members: A list of all library members.
 Methods:
 add_book(): Add a new book to the library.
 register_member(): Register a new member.
 lend_book(): Lend a book to a member if it is available.
 receive_return(): Update the status of a returned book.
 Exception Handling:
 Built-In Exceptions:
 Handle common exceptions like:
 ValueError: When invalid input is provided (e.g., trying to borrow a book that doesn’t exist).
 IndexError: When attempting to access non-existent elements in the book or member lists.
 User-Defined Exception:
 Create a custom exception called BorrowLimitExceededException that is raised when a member attempts to borrow more books than their membership type allows.
 Edge Cases:
 Borrowing Unavailable Books:

 What happens if a member tries to borrow a book that is already borrowed by another member?
 Exceeding Borrowing Limit:

 How does the system respond when a regular member attempts to borrow a fourth book or a premium member tries to borrow more than five books?
 Returning Books Not Borrowed:

 What happens if a member tries to return a book they haven’t borrowed?
 Invalid Data Entry:

 What should the system do if the librarian tries to add a book without a title or a member without a name?"""



# Custom exception
class BorrowLimitExceededException(Exception):
    def __init__(self, message="Borrow limit exceeded!"):
        super().__init__(message)

# Book class
class Book:
    def __init__(self, book_id, title, author, category):
        if not title or not author:
            raise ValueError("Book title and author cannot be empty")
        self.book_id = book_id
        self.title = title
        self.author = author
        self.status = 'available'
        self.category = category
    
    def borrow(self):
        if self.status == 'borrowed':
            raise ValueError(f"Book '{self.title}' is already borrowed.")
        self.status = 'borrowed'
    
    def return_book(self):
        if self.status == 'available':
            raise ValueError(f"Book '{self.title}' was not borrowed.")
        self.status = 'available'

# Member class
class Member:
    def __init__(self, member_id, name, member_type):
        if not name:
            raise ValueError("Member name cannot be empty")
        self.member_id = member_id
        self.name = name
        self.borrowed_books = []
        self.member_type = member_type
        self.max_books = 3 if member_type == 'Regular' else 5
    
    def borrow_book(self, book):
        if len(self.borrowed_books) >= self.max_books:
            raise BorrowLimitExceededException(f"Cannot borrow more than {self.max_books} books.")
        book.borrow()
        self.borrowed_books.append(book)
    
    def return_book(self, book):
        if book not in self.borrowed_books:
            raise ValueError(f"Book '{book.title}' was not borrowed by {self.name}.")
        book.return_book()
        self.borrowed_books.remove(book)

# Library class
class Library:
    def __init__(self):
        self.book_collection = {}
        self.members = {}
    
    def add_book(self, book_id, title, author, category):
        if book_id in self.book_collection:
            raise ValueError(f"Book with ID {book_id} already exists.")
        new_book = Book(book_id, title, author, category)
        self.book_collection[book_id] = new_book
        print(f"Book '{title}' added to the library.")
    
    def register_member(self, member_id, name, member_type):
        if member_id in self.members:
            raise ValueError(f"Member with ID {member_id} already exists.")
        new_member = Member(member_id, name, member_type)
        self.members[member_id] = new_member
        print(f"Member '{name}' registered as {member_type}.")
    
    def display_available_books(self):
        print("\nAvailable Books in the Library:")
        for book in self.book_collection.values():
            if book.status == 'available':
                print(f"ID: {book.book_id}, Title: {book.title}, Author: {book.author}, Category: {book.category}")
        print()

    def lend_book(self, member_id, book_id):
        if member_id not in self.members:
            raise ValueError("Member not found.")
        if book_id not in self.book_collection:
            raise ValueError("Book not found.")
        
        member = self.members[member_id]
        book = self.book_collection[book_id]
        
        member.borrow_book(book)
        print(f"Book '{book.title}' lent to member '{member.name}'.")

    def receive_return(self, member_id, book_id):
        if member_id not in self.members:
            raise ValueError("Member not found.")
        if book_id not in self.book_collection:
            raise ValueError("Book not found.")
        
        member = self.members[member_id]
        book = self.book_collection[book_id]
        
        member.return_book(book)
        print(f"Book '{book.title}' returned by member '{member.name}'.")

# exist data
if __name__ == "__main__":
    library = Library()

    # Add some sample books to the library
    library.add_book(1, "The Catcher in the Rye", "J.D. Salinger", "fiction")
    library.add_book(2, "Sapiens", "Yuval Noah Harari", "non-fiction")
    library.add_book(3, "1984", "George Orwell", "fiction")
    library.add_book(4, "Brief Answers to the Big Questions", "Stephen Hawking", "non-fiction")

    # Register some members
    library.register_member(1, "Alice", "Regular")
    library.register_member(2, "Bob", "Premium")

    while True:
        print("\nLibrary Management System:")
        print("1. Show available books")
        print("2. Borrow a book")
        print("3. Return a book")
        print("4. Register a new member")
        print("5. Add a new book to the library")
        print("6. Exit")

        choice = input("Enter your choice (1-6): ")

        if choice == '1':
            # Show available books
            library.display_available_books()

        elif choice == '2':
            # Borrow a book
            try:
                member_id = int(input("Enter your Member ID: "))
                library.display_available_books()
                book_id = int(input("Enter the Book ID you want to borrow: "))
                library.lend_book(member_id, book_id)
            except ValueError as e:
                print(e)
            except BorrowLimitExceededException as e:
                print(e)

        elif choice == '3':
            # Return a book
            try:
                member_id = int(input("Enter your Member ID: "))
                book_id = int(input("Enter the Book ID you want to return: "))
                library.receive_return(member_id, book_id)
            except ValueError as e:
                print(e)

        elif choice == '4':
            # Register a new member
            try:
                member_id = int(input("Enter new Member ID: "))
                name = input("Enter your name: ")
                member_type = input("Enter member type (Regular/Premium): ")
                library.register_member(member_id, name, member_type)
            except ValueError as e:
                print(e)

        elif choice == '5':
            # Add a new book to the library
            try:
                book_id = int(input("Enter new Book ID: "))
                title = input("Enter the Book Title: ")
                author = input("Enter the Author's Name: ")
                category = input("Enter the Book Category (Fiction/Non-fiction): ")
                library.add_book(book_id, title, author, category)
            except ValueError as e:
                print(e)

        elif choice == '6':
            # Exit the program
            print("Exiting the system. Goodbye!")
            break

        else:
            print("Invalid choice. Please enter a number between 1 and 6.")
