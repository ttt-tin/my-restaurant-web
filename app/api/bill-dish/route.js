import excuteQuery from "../lib/connectDb";

export const GET = async (req) => {
  try {
    const result = await excuteQuery({
      query: "SELECT * FROM bill_dishes",
    });
    return new Response(JSON.stringify(result), { status: 200 });
  } catch (error) {
    return new Response("Something wrong in server", { status: 500 });
  }
};

export const POST = async (req) => {
  try {
    const { bill_ID, dish_ID, amount } = await req.json();
    await excuteQuery({
      query: "CALL Add_Bill_dishes(?, ?, ?)",
      values: [bill_ID, dish_ID, amount],
    });
    return new Response(JSON.stringify({ msg: "Success" }), { status: 200 });
  } catch (error) {
    return new Response(JSON.stringify({ error: error }), { status: 500 });
  }
};

export const DELETE = async (req) => {
    try {
        const {bill_ID, dish_ID} = await req.json();
        await excuteQuery({
            query: "CALL Delete_Bill_dishes(?, ?)",
            values: [bill_ID, dish_ID]
        })
        return new Response(JSON.stringify({"msg": "Success"}), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error}), {status: 500})
    }
}
