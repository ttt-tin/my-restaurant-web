import mysql from 'mysql2/promise';
const db = await mysql.createConnection({
    host: process.env.MYSQL_HOST,
    database: process.env.MYSQL_DATABASE,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PASSWORD
});
export default async function excuteQuery({ query, values = [] }) {
  try {
    const results = await db.query(query, values);
    return results[0];
  } catch (error) {
    return { error: error.message };
  }
}