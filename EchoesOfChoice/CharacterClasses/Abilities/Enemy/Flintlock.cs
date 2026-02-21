using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Flintlock : Ability
    {
        public Flintlock()
        {
            Name = "Flintlock";
            FlavorText = "A crack of black powder from a sea-worn pistol.";
            ModifiedStat = StatEnum.PhysicalAttack;
            Modifier = 5;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
