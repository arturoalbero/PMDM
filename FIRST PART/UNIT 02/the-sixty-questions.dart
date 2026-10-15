void main() {
  //Question #1: Given a collection of integers, obtain a new collection containing only the even numbers.
  List<dynamic> list_i = [
    1,
    2,
    3,
    4,
  ];
  print("question 01");
  print("initial list: ");
  print(list_i);
  print(list_i.where((n) => n % 2 == 0));
  print("---\n---");

  //Question #2: Given a collection of integers, obtain only those that are greater than zero.
  list_i = [-3, 2, -1, 0, 23, 17, -90];
  print("question 02");
  print("initial list: ");
  print(list_i);
  print(list_i.where((n) => n > 0));
  print("---\n---");

  //Question #3: Given a collection of numbers, create another collection where each number is doubled.
  print("question 03");
  print("initial list: ");
  print(list_i);
  print(list_i.map((n) => n * 2));
  print("---\n---");

  //Question #4: Given a collection of integers, create a new collection containing the square of each number.
  print("question 04");
  print("initial list: ");
  print(list_i);
  print(list_i.map((n) => n * n));
  print("---\n---");

  //Question #5: Given a collection of words, create a collection containing the length of each word.
  var list_s = [
    "Juan",
    "Pedro",
    "Aureliana",
    "Esternocleidomastoideo",
    "Souvenir",
    "Amadeus",
    "Francia",
    "A",
    "Bé",
    "Ceh",
    "Dehe",
    "arnold"
  ];
  print("question 05");
  print("initial list: ");
  print(list_s);
  print(list_s.map((n) => n.length));
  print("---\n---");

  //Question #6: Given a collection of words, obtain only those that contain more than 5 characters.
  print("question 06");
  print("initial list: ");
  print(list_s);
  print(list_s.where((s)=> s.length > 5));
  print("---\n---");

  //Question #7: Given a collection of words, create another collection with all the words converted to uppercase.
  print("question 07");
  print("initial list: ");
  print(list_s);
  print(list_s.map((s)=>s.toUpperCase()));
  print("---\n---");

  //Question #8: Given a collection of integers, filter the even numbers and calculate the square of each one.
  print("question 08");
  print("initial list: ");
  print(list_i);
  print(list_i.where((n)=>n%2 == 0).map((n)=>n*n));
  print("---\n---");

  //Question #9: Given a collection of words, keep the words with more than 4 characters and convert them to uppercase.
  print("question 09");
  print("initial list: ");
  print(list_s);
  print(list_s.where((s)=>s.length > 4).map((s)=>s.toUpperCase()));
  print("---\n---");

  //Question #10: Given a collection of numbers, keep only the positive numbers and multiply each one by 10.
  print("question 10");
  print("initial list: ");
  print(list_i);
  print(list_i.where((n)=>n>=0).map((n)=>n*10));
  print("---\n---");

  //Question #11: Given a collection of names, obtain the names that start with the letter A and convert them to uppercase.
  print("question 11");
  print("initial list: ");
  print(list_s);
  print(list_s.where((s)=>s.startsWith("A")).map((s)=>s.toUpperCase()));
  print("---\n---");

  //Question #12: Given a collection of prices, create a new collection applying a 20% discount only to prices greater than 100.
  var list_f = [50.75, 20.84, 1000.99, 100.01, 275.42];

  print("question 12");
  print("initial list: ");
  print(list_f);
  print(list_f.where((n)=> n>100.0).map((n)=>n*0.80));
  print("---\n---");

  //Question #13: Given a collection of numbers, calculate the sum of all its elements.
  print("question 13");
  print("initial list: ");
  print(list_f);
  print(list_f.reduce((s,a)=> s+a));
  print("---\n---");

  //Question #14: Given a collection of numbers, calculate the product of all its elements.
  print("question 14");
  print("initial list: ");
  print(list_f);
  print(list_f.reduce((s,a)=> s*a));
  print("---\n---");

  //Question #15: Given a collection of numbers, obtain the largest number.
  print("question 15");
  print("initial list: ");
  print(list_f);
  //se guarda el número mayor cada vez y al final solamente queda ese. El valor inicial de s es 0.
  print(list_f.reduce((s,a)=> (s > a)? s : a ));
  print("---\n---");

  //Question #16: Given a collection of numbers, obtain the smallest number.
  print("question 16");
  print("initial list: ");
  print(list_f);
  //se guarda el número menor cada vez y al final solamente queda ese. El valor inicial de s es 0.
  print(list_f.reduce((s,a)=> (s < a)? s : a ));
  print("---\n---");

  //Question #17: Given a collection of numbers, filter the even numbers and calculate their sum.
  print("question 17");
  print("initial list: ");
  print(list_i);

  print(list_i.where((n)=>n%2==0).reduce((s,a)=>s+a));
  print("---\n---");

  //Question #18: Given a collection of numbers, calculate their arithmetic mean using functional operations instead of an explicit loop.
  print("question 18");
  print("initial list: ");
  print(list_i);
  print(list_i.reduce((s,a)=>s+a)/list_i.length);
  print("---\n---");

  //Question #19: Given a collection of numbers, calculate the square of each number and sum all the results.
  print("question 19");
  print("initial list: ");
  print(list_i);
  print(list_i.map((n)=>n*n).reduce((s,a)=>s+a));
  print("---\n---");

  //Question #20: Given a collection of numbers, keep the even numbers, square each one, and sum the results.
  print("question 20");
  print("initial list: ");
  print(list_i);
  print(list_i.where((n)=>n%2==0).map((n)=>n*n).reduce((s,a)=>s+a));
  print("---\n---");

  //Question #21: Given a collection of numbers, determine whether there is at least one negative number.
  print("question 21");
  print("initial list: ");
  print(list_i);
  print((list_i.where((n)=>n<0).length > 0)?"Hay negativos":"no hay negativos");
  print("List with no negative numbers:");
  var list_i_posi = [1,2,3,4];
  print((list_i_posi.where((n)=>n<0).length > 0)?"Hay negativos":"no hay negativos");
  print("---\n---");

  //Question #22: Given a collection of numbers, determine whether all its elements are greater than zero.

  //Question #23: Given a collection of numbers, determine whether none of them is equal to zero.

  //Question #24: Given a collection of numbers, find the first even number. If there is none, return a result representing the absence of a value.

  //Question #25: Given a collection of words and a specific word, determine whether that word is present in the collection.

  //Question #26: Given a collection of names, find the first name that contains more than 7 characters.

  //Question #27: Given a collection of products, where each product has a name, price, category, and stock quantity, obtain all products whose price is greater than 100.

  //You can use a class for the product, but a MAP <ATTRIBUTE : VALUE> or even an Array (just know in which position is the value of each attribute) could work. You can use this workaround for customers, invoices, students or any complex data you may need.

  //Question #28: Given a collection of products, obtain a collection containing only the names of all the products.

  //Question #29: Given a collection of products, obtain the products whose stock quantity is zero.

  //Question #30: Given a collection of products, obtain a collection containing the price of each product increased by 21%.

  //Question #31: Given a collection of products, obtain the names of the products whose price is less than 20.

  //Question #32: Given a collection of products, calculate the total inventory value. For each product, calculate price × stock quantity and sum all the results.

  //Question #33: Given a collection of products, determine whether there is at least one product whose stock quantity is zero.

  //Question #34: Given a collection of products, determine whether all products have at least one unit available.

  //Question #35: Given a collection of products, obtain the product with the highest price.

  //Question #36: Given a collection of products, obtain the product with the lowest price.

  //Question #37: Given a collection of numbers, obtain a new collection sorted from smallest to largest.

  //Question #38: Given a collection of numbers, sort it from largest to smallest.

  //Question #39: Given a collection of products, sort them by price from lowest to highest.

  //Question #40: Given a collection of products, sort them alphabetically by name.

  //Question #41: Given a collection of numbers that may contain duplicate values, create a collection containing each number only once.

  //Question #42: Given a collection of words, remove duplicate words while ignoring differences in uppercase and lowercase letters.

  //Question #43: Given a collection of products, group them by category.

  //Question #44: Given a collection of products, determine how many products there are in each category.

  //Question #45: Given a collection of products, calculate the average price of the products in each category.

  //Question #46: Given a collection of products, find the most expensive product in each category.

  //Question #47: Given a collection of collections of numbers, create a single collection containing all the numbers.

  //Question #48: Given a collection of sentences, obtain a single collection containing all the words from all the sentences.

  //Question #49: Given a collection of customers, where each customer has a collection of orders, obtain a single collection containing all the orders from all customers.

  //Question #50: Given a collection of orders, where each order contains a collection of products, obtain a single collection containing all the products included in all orders and remove duplicate products.

  //Question #51: Given a collection of products, remove products that are out of stock, sort them by price from highest to lowest, take only the first 5, and return their names.

  //Question #52: Given a collection of products and a specific category, filter the products belonging to that category, remove those that are out of stock, sort them by price, and obtain their names.

  //Question #53: Given a collection of numbers, calculate the number of elements, the minimum, the maximum, the sum, the average, the number of even numbers, and the number of odd numbers.

  //Question #54: Given a collection of users, where each user has a name, age, and active status, keep only active users who are adults and obtain their names sorted alphabetically.

  //Question #55: Given a collection of users, calculate the average age, find the oldest user, determine whether there is at least one minor, determine whether all users are active, and obtain the names of the active users.

  //Question #56: Given a collection of invoice lines, where each line has a product, quantity, and unit price, calculate the total invoice amount. For each line, calculate quantity × unit price and then sum all the amounts.

  //Question #57: Given a collection of invoice lines, calculate the amount for each line, apply a 10% discount to lines whose amount is greater than 500, and sum all the final amounts.

  //Question #58: Given a collection of students, where each student has a name and a collection of grades, calculate the average grade for each student, obtain the students whose average is greater than or equal to 5, obtain the names of the passing students, and calculate the average grade for the entire class.

  //Question #59: Given a collection of sentences, split the sentences into words, convert all words to lowercase, remove punctuation marks, count how many times each word appears, and obtain the words that appear more than 5 times.

  //Question #60: Given a collection of products, where each product has a name, price, category, and stock quantity, discard products that are out of stock, keep products whose price is between 20 and 200, apply a 15% discount, sort them by final price from highest to lowest, take the first 10, and obtain only their names.
}
