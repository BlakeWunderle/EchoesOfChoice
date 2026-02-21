using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class RazorWind : Ability
    {
        public RazorWind()
        {
            Name = "Razor Wind";
            FlavorText = "A blade of compressed air slices with surgical precision.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
