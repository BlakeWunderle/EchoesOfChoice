using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Miasma : Ability
    {
        public Miasma()
        {
            Name = "Miasma";
            FlavorText = "Spread a toxic miasma that weakens all enemies.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 4;
            TargetAll = true;
        }
    }
}
