using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class SporeCloud : Ability
    {
        public SporeCloud()
        {
            Name = "Spore Cloud";
            FlavorText = "Release a cloud of weakening spores that saps enemy strength.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
            TargetAll = true;
        }
    }
}
