// Import MongoDB client
const { MongoClient } = require('mongodb');

// Connection URL and Database Name
const url = 'mongodb://localhost:27017';  // Update with your MongoDB URI if different
const dbName = 'CUSTOMER_ORDER';

async function updateOrderStatus(orderId) {
  // Create a new MongoDB client and connect to the database
  const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });

  try {
    // Connect to MongoDB server
    await client.connect();
    console.log("Connected to MongoDB");

    // Access the database and collection
    const db = client.db(dbName);
    const ordersCollection = db.collection('order');

    // Step 1: Update the order's status to "delivered" where the order_id matches
    const result = await ordersCollection.updateOne(
      { order_id: orderId },  // Query to find the order by order_id
      { $set: { status: "delivered" } }  // Update the status field to "delivered"
    );

    if (result.modifiedCount > 0) {
      console.log(`Order ${orderId} status updated to "delivered".`);
    } else {
      console.log(`Order ${orderId} not found or already has "delivered" status.`);
    }
  } catch (err) {
    console.error("An error occurred:", err);
  } finally {
    // Close the connection
    await client.close();
  }
}

// Run the function to update the status of order "ORD123456"
updateOrderStatus("ORD123461");
