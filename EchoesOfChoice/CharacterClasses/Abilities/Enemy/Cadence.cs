using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Cadence : Ability
    {
        public Cadence()
        {
            Name = "Cadence";
            FlavorText = "A hypnotic rhythm leaves the target sluggish and disoriented.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
