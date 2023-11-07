export function getTimePlus(
    seconds?: number,
    minutes?: number,
    hours?: number,
    days?: number,
    months?: number,
    years?: number,
    ) {
    let now = new Date();
    if (seconds) now.setSeconds(now.getSeconds() + seconds);
    if (minutes) now.setMinutes(now.getMinutes() + minutes);
    if (hours) now.setHours(now.getHours() + hours);
    if (days) now.setDate(now.getDate() + days);
    if (months) now.setMonth(now.getMonth() + months);
    if (years) now.setFullYear(now.getFullYear() + years);
    return (now.getTime() / 1000).toFixed(0);
}
