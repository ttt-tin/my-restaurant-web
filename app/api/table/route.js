import excuteQuery from "../lib/connectDb";

export const GET = async (req) => {
  try {
    const result = await excuteQuery({
      query: "SELECT * FROM table_common",
    });
    return new Response(JSON.stringify(result), { status: 200 });
  } catch (error) {
    return new Response("Something wrong in server", { status: 500 });
  }
};