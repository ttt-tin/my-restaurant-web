import excuteQuery from "@app/api/lib/connectDb"

export const GET = async (req, { params }) => {
    try {
        const day = params.day;
        console.log(day)
        const result = await excuteQuery({
            query: "CALL DISH_ON_DISCOUNT(?)",
            values: [day]
        })
        return new Response(JSON.stringify(result[0]), {status: 200})
    } catch (error) {
        return new Response(JSON.stringify({error: error.message}), {status: 500})
    }
}