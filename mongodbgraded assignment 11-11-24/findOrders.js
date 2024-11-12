// Import MongoDB client
const { MongoClient, ObjectId } = require('mongodb');

// Connection URL and Database Name
const url = 'mongodb://localhost:27017';  // Update with your MongoDB URI if different
const dbName = 'CUSTOMER_ORDER';

async function findOrdersForCustomer(customerName) {
  // Create a new MongoDB client and connect to the database
  const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });

  try {
    // Connect to MongoDB server
    await client.connect();
    console.log("Connected to MongoDB");

    // Access the database and collections
    const db = client.db(dbName);
    const customersCollection = db.collection('customers');
    const ordersCollection = db.collection('order');

    // Step 1: Find the _id of the customer with the given name
    const customer = await customersCollection.findOne({ name: customerName });

    if (customer) {
      // Step 2: Use the customer's _id to find all orders
      const orders = await ordersCollection.find({ customer_id: customer._id }).toArray();
      
      // Display the orders
      console.log(`Orders for customer ${customerName}:`);
      console.log(orders);
    } else {
      console.log(`Customer with name '${customerName}' not found.`);
    }
  } catch (err) {
    console.error("An error occurred:", err);
  } finally {
    // Close the connection
    await client.close();
  }
}

// Run the function
findOrdersForCustomer("John Doe");
