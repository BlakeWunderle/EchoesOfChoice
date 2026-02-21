using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Proof : Ability
    {
        public Proof()
        {
            Name = "Proof";
            FlavorText = "Pull out a blackboard and stump your enemy with your big brains. Lowers magical defenses";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
