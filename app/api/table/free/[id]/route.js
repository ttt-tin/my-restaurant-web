import excuteQuery from "@app/api/lib/connectDb"

export const GET = async (req, { params }) => {
  try {
    const id = params.id
    const result = await excuteQuery({
      query: "SELECT check_status(?) as result",
      values: [id]
    });
    return new Response(JSON.stringify(result), { status: 200 });
  } catch (error) {
    return new Response("Something wrong in server", { status: 500 });
  }
};