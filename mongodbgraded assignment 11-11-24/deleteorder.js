// Import MongoDB client
const { MongoClient } = require('mongodb');

// Connection URL and Database Name
const url = 'mongodb://localhost:27017';  // Update with your MongoDB URI if needed
const dbName = 'CUSTOMER_ORDER';

async function deleteOrder(orderId) {
  // Create a new MongoDB client and connect to the database
  const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });

  try {
    // Connect to MongoDB server
    await client.connect();
    console.log("Connected to MongoDB");

    // Access the database and collection
    const db = client.db(dbName);
    const ordersCollection = db.collection('order');

    // Step 1: Delete the order where the order_id matches
    const result = await ordersCollection.deleteOne({ order_id: orderId });

    if (result.deletedCount > 0) {
      console.log(`Order ${orderId} deleted successfully.`);
    } else {
      console.log(`Order ${orderId} not found.`);
    }
  } catch (err) {
    console.error("An error occurred:", err);
  } finally {
    // Close the connection
    await client.close();
  }
}

// Run the function to delete the order "ORD123456"
deleteOrder("ORD123459",);
