import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

export let errorRate = new Rate('errors');

export let options = {
  rps: 1000,
  stages: [
    { duration: '1s', target: 1 },
    { duration: '30s', target: 10 },
    { duration: '5s', target: 0 },
  ],
};

const HOST = __ENV.HOST || 'http://localhost';
export function setup() {
  console.log("SETUP: Creating a new product for the test...");

  const productPayload = JSON.stringify({
    name: "Load Test Product",
    price: 50000,
    qty: 100000,
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  let res = http.post(`${HOST}:3000/products`, productPayload, params);

  check(res, {
    'product created successfully': (r) => r.status === 201,
  });

  let product = res.json();
  let productId = product.id;

  console.log(`SETUP: Product created with ID: ${productId}`);

  return { productId };
}

export default function (data) {
  const productId = data.productId;

  const payload = JSON.stringify({
    productId: productId,
    quantity: Math.floor(Math.random() * 5) + 1
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  let response = http.post(`${HOST}:8000/orders`, payload, params);

  let success = check(response, {
    'status is 201': (r) => r.status === 201,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  errorRate.add(!success);

  sleep(0.1);
}