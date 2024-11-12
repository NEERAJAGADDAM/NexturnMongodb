

Part 2: Aggregation Pipeline:

----------------------------------------------
1. Calculate Total Value of All Orders by Customer:

o Write a script to calculate the total value of all orders for each customer. 
This should return each customer’s name and the total order value.
----------------------------------------------
CUSTOMER_ORDER> db.orders.aggregate([
... {
...  $lookup: {
...  from: "customers",
... localField: "customer_id",
... foreignField: "_id",
... as: "customer"
... }
... },
... {
... $unwind: "$customer"
... },
... {
... $group: {
... _id: "$customer._id",
... name: { $first: "$customer.name" },
... totalOrderValue: {
...  $sum: "$total_value"
... }
... }
... },
... {
...  $project: {
... _id:0,
... name:1,
... totalOrderValue:1
... }
... }
... ]);
---------------------------------------------

2. Group Orders by Status:

Write a script to group orders by their status (e.g., “shipped”, “delivered”, etc.)
 and count how many orders are in each status.
 -------------------------------------------
 CUSTOMER_ORDER> db.orders.aggregate([
...   {
...     $group: {
...       _id: "$status",           
...       orderCount: { $sum: 1 }   
...     }
...   },
...   {
...     $project: {
...       _id: 0,                   
...       status: "$_id",          
...       orderCount: 1             
...     }
...   }
... ]);
-------------------------------------------

3. List Customers with Their Recent Orders:

o Write a script to find each customer and their most recent order. Include customer information such as name, email, and order details (e.g., order_id, total_value).

db.orders.aggregate([
    { $sort: { order_date: -1 } },
    { $group: { _id: "$customer_id", recent_order: { $first: "$$ROOT" } } },
    { $lookup: { from: "customers", localField: "_id", foreignField: "_id", as: "customer" } },
    { $unwind: "$customer" },
    { $project: { name: "$customer.name", email: "$customer.email", order_id: "$recent_order.order_id", total_value: "$recent_order.total_value" } }
]);
{
  _id: ObjectId('1234567890abcdef12345678'),
  name: 'Neeraja',
  email: 'neerajagaddam76@gmail.com',
  order_id: 'ORD123457',
  total_value: 750
}
{
  _id: ObjectId('1234567890abcdef12345679'),
  name: 'John Smith',
  email: 'johnsmith@example.com',
  order_id: 'ORD123458',
  total_value: 325
}
--------------------------------------------------------------
4. Find the Most Expensive Order by Customer:

o Write a script to find the most expensive order for each customer. Return the customer’s name and the details of their most expensive order (e.g., order_id, total_value).
db.orders.aggregate([
  {
    $sort: { total_value: -1 }  // Sort by total_value in descending order
  },
  {
    $group: {
      _id: "$customer_id",               // Group by customer_id
      most_expensive_order: { $first: "$$ROOT" }  // Get the most expensive order for each customer
    }
  },
  {
    $lookup: {
      from: "customers",                 // Join with the customers collection
      localField: "_id",                 // Use the customer_id from the orders
      foreignField: "_id",               // Match it with the _id field in customers
      as: "customer_info"                // Store the joined data in "customer_info"
    }
  },
  {
    $unwind: "$customer_info"            // Flatten the customer_info array
  },
  {
    $project: {
      _id: 0,                            // Exclude _id
      name: "$customer_info.name",       // Include customer name
      order_id: "$most_expensive_order.order_id",     // Include order_id of the most expensive order
      total_value: "$most_expensive_order.total_value" // Include total value of the most expensive order
    }
  }
]);

{
  name: 'John Smith',
  order_id: 'ORD123458',
  total_value: 325
}
{
  name: 'Neeraja',
  order_id: 'ORD123457',
  total_value: 750
}
---------------------------------------------------------
Part 3: Real-World Scenario with Relationships

Objective: Apply MongoDB operations to a real-world problem involving two related collections.

Scenario: You are working as a MongoDB developer for an e-commerce platform. 
The system needs to track customer orders, including the customer’s name, email, and address, as well as the items they ordered.
--------------------------------------------------------
1. Find All Customers Who Placed Orders in the Last Month:

o Write a script to find all customers who have placed at least one order in the last 30 days. 
Return the customer name, email, and the order date for their most recent order.

db.orders.aggregate([
    { $match: { order_date: { $gte: new Date(new Date().setMonth(new Date().getMonth() - 1)) } } },
    { $group: { _id: "$customer_id", recent_order: { $first: "$$ROOT" } } },
    { $lookup: { from: "customers", localField: "_id", foreignField: "_id", as: "customer" } },
    { $unwind: "$customer" },
    { $project: { name: "$customer.name", email: "$customer.email", order_date: "$recent_order.order_date" } }
]);

---------------------------------------------------------------------------------------------------
2. Find All Products Ordered by a Specific Customer:

o Write a script to find all distinct products ordered by a customer with the name “John Doe”. Include the product name and the total quantity ordered.

db.orders.aggregate([
  {
    $lookup: {
      from: "customers",           // The collection to join with
      localField: "customer_id",    // Field from orders
      foreignField: "_id",          // Field from customers (_id)
      as: "customer"                // Output field to store the joined customer data
    }
  },
  {
    $unwind: "$customer"           // Flatten the customer array so each order has customer data
  },
  {
    $group: {
      _id: "$customer_id",              // Group by customer_id to aggregate total order value
      name: { $first: "$customer.name" },  // Get the name of the customer
      total_order_value: { $sum: "$total_value" }  // Sum the total_value of all orders per customer
    }
  },
  {
    $sort: { total_order_value: -1 }   // Sort by total_order_value in descending order
  },
  {
    $limit: 3                          // Limit the result to the top 3 customers
  },
  {
    $project: {
      _id: 0,                          // Exclude the _id field
      name: 1,                         // Include the customer name
      total_order_value: 1             // Include the total order value
    }
  }
]);

{
  name: 'Neeraja',
  total_order_value: 750
}
{
  name: 'John Smith',
  total_order_value: 325
}
-----------------------------------------------------------------------

3. Find the Top 3 Customers with the Most Expensive Total Orders:

o Write a script to find the top 3 customers who have spent the most on orders. Sort the results by total order value in descending order.


--------------------------------------------------------------
db.order.aggregate([
  {
    $lookup: {
      from: "customers",           // The collection to join with
      localField: "customer_id",    // Field from orders
      foreignField: "_id",          // Field from customers (_id)
      as: "customer"                // Output field to store the joined customer data
    }
  },
  {
    $unwind: "$customer"           // Flatten the customer array so each order has customer data
  },
  {
    $group: {
      _id: "$customer_id",              // Group by customer_id to aggregate total order value
      name: { $first: "$customer.name" },  // Get the name of the customer
      total_order_value: { $sum: "$total_value" }  // Sum the total_value of all orders per customer
    }
  },
  {
    $sort: { total_order_value: -1 }   // Sort by total_order_value in descending order
  },
  {
    $limit: 3                          // Limit the result to the top 3 customers
  },
  {
    $project: {
      _id: 0,                          // Exclude the _id field
      name: 1,                         // Include the customer name
      total_order_value: 1             // Include the total order value
    }
  }
]);

{
  name: 'Neeraja',
  total_order_value: 750
}
{
  name: 'John Smith',
  total_order_value: 325
}
-----------------------------------------------------------------
4. Add a New Order for an Existing Customer:


o Write a script to add a new order for a customer with the name “Jane Smith”. The order should include at least two items, such as “Smartphone” and “Headphones”.

db.orders.insertOne({
    order_id: "ORD123461",
    customer_id: ObjectId("67320c549ec744648a0d8191"),
    order_date: new Date("2023-08-01T14:00:00Z"),
    status: "pending",
    items: [
        { product_name: "Smartphone", quantity: 1, price: 700 },
        { product_name: "Headphones", quantity: 2, price: 50 }
    ],
    total_value: 800
});
{
  acknowledged: true,
  insertedId: ObjectId('6732c278c0fb9722bc26128c')
}
------------------------------------------------------
Part 4: Bonus Challenge

Objective: Demonstrate the ability to work with advanced MongoDB operations and complex relationships.
-------------------------------------------------------
1. Find Customers Who Have Not Placed Orders:

o Write a script to find all customers who have not placed any orders. Return the customer’s name and email.

db.customers.aggregate([
  {
    $lookup: {
      from: "orders",             // Join with the orders collection
      localField: "_id",          // The field from customers to match
      foreignField: "customer_id", // The field from orders to match
      as: "orders"                // Store the joined order data in "orders" field
    }
  },
  {
    $match: { orders: { $size: 0 } }  // Filter for customers with an empty orders array
  },
  {
    $project: {
      _id: 0,                       // Exclude _id
      name: 1,                      // Include customer name
      email: 1                      // Include customer email
    }
  }
]);
{
  name: 'Neeraja',
  email: 'neerajagaddam76@gmail.com'
}
{
  name: 'John Smith',
  email: 'johnsmith@example.com'
}
{
  name: 'Alice Johnson',
  email: 'alicejohnson@example.com'
}
{
  name: 'Robert Brown',
  email: 'robertbrown@example.com'
}
{
  name: 'Jane Doe',
  email: 'janedoe@example.com'
}
-----------------------------------------------------------------
2. Calculate the Average Number of Items Ordered per Order:

o Write a script to calculate the average number of items ordered per order across all orders. The result should return the average number of items.

db.orders.aggregate([
  {
    $unwind: "$items"                   // Flatten the items array so each item is a separate document
  },
  {
    $group: {
      _id: "$_id",                      // Group by order_id
      items_count: { $sum: 1 }          // Count the number of items per order
    }
  },
  {
    $group: {
      _id: null,                        // Group all orders together
      avg_items_per_order: { $avg: "$items_count" }  // Calculate the average items count across all orders
    }
  },
  {
    $project: {
      _id: 0,                           // Exclude _id
      avg_items_per_order: 1            // Include the average items per order
    }
  }
]);

{
  avg_items_per_order: 2
}
------------------------------------------------------------------------
3. Join Customer and Order Data Using $lookup:

o Write a script using the $lookup aggregation operator to join data from the customers collection and the 
orders collection. Return customer name, email, order details (order_id, total_value), and order date.


db.orders.aggregate([
    { $group: { _id: "$customer_id", order_count: { $sum: 1 } } },
    { $lookup: { from: "customers", localField: "_id", foreignField: "_id", as: "customer" } },
    { $unwind: "$customer" },
    { $project: { name: "$customer.name", order_count: 1 } }
]);
{
  _id: ObjectId('1234567890abcdef12345679'),
  order_count: 1,
  name: 'John Smith'
}
{
  _id: ObjectId('1234567890abcdef12345678'),
  order_count: 1,
  name: 'Neeraja'
}
------------------------------------------