import excuteQuery from "@app/api/lib/connectDb"

export const GET = async (req, { params }) => {
    try {
        const day = JSON.stringify(params.day);
        console.log(day)
        const result = await excuteQuery({
            query: "CALL DISH_ON_DISCOUNT(?)",
            values: [day]
        })
        return new Response(JSON.stringify(result), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error.message}), {status: 500})
    }
}