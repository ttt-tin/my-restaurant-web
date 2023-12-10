import excuteQuery from "../lib/connectDb";

export const GET = async (req) => {
  try {
    const result = await excuteQuery({
      query: "SELECT * FROM bill",
    });
    return new Response(JSON.stringify(result), { status: 200 });
  } catch (error) {
    return new Response("Something wrong in server", { status: 500 });
  }
};

export const POST = async (req) => {
  try {
    const {
      Start_time,
      End_time,
      Num_of_people,
      Total_discount,
      Total_payment,
      Staff_ID,
    } = await req.json();
    await excuteQuery({
      query: "CALL insert_bill(?, ?, ?, ?, ?, ?)",
      values: [
        Start_time,
        End_time,
        Num_of_people,
        Total_discount,
        Total_payment,
        Staff_ID,
      ],
    });
    return new Response(JSON.stringify({ msg: "Success" }), { status: 200 });
  } catch (error) {
    return new Response(JSON.stringify({ error: error }), { status: 500 });
  }
};

export const DELETE = async (req) => {
    try {
        const {Bill_ID} = await req.json();
        await excuteQuery({
            query: "CALL delete_bill(?)",
            values: [Bill_ID]
        })
        return new Response(JSON.stringify({"msg": "Success"}), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error}), {status: 500})
    }
}