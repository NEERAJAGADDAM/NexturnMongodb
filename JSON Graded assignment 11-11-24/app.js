const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Read and parse data.json
function loadProducts() {
    try {
        const data = fs.readFileSync('data.json', 'utf8');
        return JSON.parse(data);
    } catch (error) {
        console.error("Error loading data:", error);
        return [];
    }
}

// Save products to data.json
function saveProducts(products) {
    fs.writeFileSync('data.json', JSON.stringify(products, null, 4));
}

// Ask a question in the terminal
function askQuestion(query) {
    return new Promise(resolve => rl.question(query, resolve));
}

// Add a new product based on user input
async function addProduct(products) {
    const id = parseInt(await askQuestion("Enter product ID: "));
    const name = await askQuestion("Enter product name: ");
    const category = await askQuestion("Enter product category: ");
    const price = parseFloat(await askQuestion("Enter product price: "));
    const available = (await askQuestion("Is the product available? (yes/no): ")).toLowerCase() === 'yes';

    const newProduct = { id, name, category, price, available };
    products.push(newProduct);
    console.log("Product added:", newProduct);
}

// Update product price based on user input
async function updateProductPrice(products) {
    const productId = parseInt(await askQuestion("Enter product ID to update price: "));
    const newPrice = parseFloat(await askQuestion("Enter new price: "));

    const product = products.find(p => p.id === productId);
    if (product) {
        product.price = newPrice;
        console.log(`Updated price for product ID ${productId}:`, product);
    } else {
        console.log(`Error: Product with ID ${productId} not found.`);
    }
}

// Filter products based on availability
function filterAvailableProducts(products) {
    const availableProducts = products.filter(product => product.available);
    console.log("Available products:", availableProducts);
    return availableProducts;
}

// Filter products by category based on user input
async function filterProductsByCategory(products) {
    const category = await askQuestion("Enter category to filter by: ");
    const filteredProducts = products.filter(product => product.category === category);
    console.log(`Products in category '${category}':`, filteredProducts);
    return filteredProducts;
}

// Main function to handle user choices
async function main() {
    const products = loadProducts();

    while (true) {
        const choice = await askQuestion(`Choose an option:
        1. Add a new product
        2. Update the price of a product
        3. Show available products
        4. Filter products by category
        5. Exit\n`);

        switch (choice) {
            case '1':
                await addProduct(products);
                saveProducts(products); // Save changes to file
                break;
            case '2':
                await updateProductPrice(products);
                saveProducts(products); // Save changes to file
                break;
            case '3':
                filterAvailableProducts(products);
                break;
            case '4':
                await filterProductsByCategory(products);
                break;
            case '5':
                console.log("Exiting program.");
                rl.close();
                return;
            default:
                console.log("Invalid choice. Please try again.");
        }
    }
}

// Run the main program
main();
