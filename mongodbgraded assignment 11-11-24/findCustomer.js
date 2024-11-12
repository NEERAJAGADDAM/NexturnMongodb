// Import MongoDB client
const { MongoClient, ObjectId } = require('mongodb');

// Connection URL and Database Name
const url = 'mongodb://localhost:27017';  // Update with your MongoDB URI if needed
const dbName = 'CUSTOMER_ORDER';

async function findCustomerForOrder(orderId) {
  // Create a new MongoDB client and connect to the database
  const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });

  try {
    // Connect to MongoDB server
    await client.connect();
    console.log("Connected to MongoDB");

    // Access the database and collections
    const db = client.db(dbName);
    const ordersCollection = db.collection('order');
    const customersCollection = db.collection('customers');

    // Step 1: Find the order document by order_id
    const order = await ordersCollection.findOne({ order_id: orderId });

    if (order) {
      // Step 2: Use the customer_id from the order to find the customer
      const customer = await customersCollection.findOne({ _id: order.customer_id });

      // Display the customer information
      if (customer) {
        console.log(`Customer information for order ${orderId}:`);
        console.log(customer);
      } else {
        console.log(`Customer with ID '${order.customer_id}' not found.`);
      }
    } else {
      console.log(`Order with ID '${orderId}' not found.`);
    }
  } catch (err) {
    console.error("An error occurred:", err);
  } finally {
    // Close the connection
    await client.close();
  }
}

// Run the function
findCustomerForOrder("ORD123457");
