using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Gravity : Ability
    {
        public Gravity()
        {
            Name = "Gravity";
            FlavorText = "Warp gravitational forces to slow an enemy to a crawl. Lowers speed.";
            ModifiedStat = StatEnum.Speed;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
